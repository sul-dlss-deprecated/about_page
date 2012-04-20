module AboutPage
  class Dependencies
    delegate :each_pair, :to_xml, :to_json, :to => :to_h
    def to_h
      @dependencies ||= Hash[groups.collect { |group,deps| [group,Hash[deps.collect { |dep| [dep.name,dependency_hash(environment, dep.name)] }]] }]
    end

    private
    def environment
      @environment ||= Bundler.load
    end

    def groups
      @groups ||= environment.current_dependencies.group_by { |d| d.groups.first.to_s }
    end

    def dependency_version(env, key)
      spec = env.specs.find { |s| s.name == key }
      rev = spec.git_version
      rev.strip! unless rev.nil?
      location = [spec.source.options.values_at('path','uri').compact.first,rev].compact.join('@')
      [spec.version.to_s,location].compact.join(' ').strip
    end
    
    def dependency_hash(env, key, graph=nil)
      graph = Bundler::Graph.new(env,'/dev/null') if graph.nil?
      result = { :version => dependency_version(env, key) }
      deps = Hash[graph.relations[key].collect { |dep| [dep, dependency_hash(env, dep, graph)]}]
      result[:dependencies] = deps unless deps.empty?
      result
    end
  end
end
