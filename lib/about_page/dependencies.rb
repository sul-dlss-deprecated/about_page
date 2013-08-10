module AboutPage
  class Dependencies < AboutPage::Configuration::Node
    attr_reader :max_depth

    def initialize(max_depth=100)
      @max_depth = max_depth
    end

    def to_h
      @dependencies ||= spec_list.inject({}) { |h,data|
        spec = { :name => data[0], :version => data[1] }
        if data[2].nil?
          h[:implied] ||= []
          h[:implied] << spec
        else
          data[2].each { |g|
            h[g] ||= []
            h[g] << spec
          }
        end
        h
      }
    end

    def spec_list
      ruby_ver = "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
      required = environment.current_dependencies.inject({}) { |h,d| h[d.name] = d.groups; h }
      list = [[
        RUBY_ENGINE,
        Module.const_defined?(:JRUBY_VERSION) ? "#{JRUBY_VERSION}r#{JRUBY_REVISION} (#{ruby_ver})" : ruby_ver,
        ['system']
      ]] + environment.specs.sort { |a,b| a.name <=> b.name }.collect { |s| [
        s.name,
        [s.version.to_s, s.git_version.to_s].join,
        required[s.name]
      ]}
      list
    end

    private
    def environment
      @environment ||= Bundler.load
    end

    def groups
      @groups ||= environment.current_dependencies.group_by { |d| d.groups.first.to_s }
    end

    def specs
      @specs ||= environment.specs
    end

    def dependency_version(key)
      spec = environment.specs.find { |s| s.name == key }
      rev = spec.git_version
      rev.strip! unless rev.nil?
      location = [spec.source.options.values_at('path','uri').compact.first,rev].compact.join('@')
      [spec.version.to_s,location].compact.join(' ').strip
    end

    def dependency_hash(key, graph=nil, depth=0)
      graph = Bundler::Graph.new(environment,'/dev/null') if graph.nil?
      result = { :version => dependency_version(key) }
      if depth < @max_depth
        deps = Hash[graph.relations[key].collect { |dep| [dep, dependency_hash(dep, graph, depth+1)]}]
        result[:dependencies] = deps unless deps.empty?
      end
      result
    end
  end
end
