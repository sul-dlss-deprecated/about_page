require 'rugged'

module AboutPage
  class GitLog  < AboutPage::Configuration::Node
    attr_reader :commits
    
    def initialize(opts = {})
      root  = opts.fetch(:root, Rails.root)
      @limit = opts.fetch(:limit, %r{/tags/})
      @repo = Rugged::Repository.new(root.to_s)
      @fetch = !!opts[:fetch]
      if opts[:remotes]
        opts[:remotes].each_pair do |name, location|
          if @repo.remotes[name.to_s].nil?
            @repo.remotes.create(name.to_s, location)
          end
        end
      end
    end
    
    def find_commit(ref)
      target = ref
      while not (target.nil? or target.is_a?(Rugged::Commit))
        target = target.target  
      end
      target
    end
    
    def commits
      @repo.remotes.each { |remote| remote.fetch rescue nil } if @fetch
      refs = @repo.refs.inject(Hash.new { |h,k| h[k] = [] }) { |h,r| h[find_commit(r).oid] << r.name; h }
      result = []
      walker = Rugged::Walker.new(@repo)
      walker.push(@repo.head.name)
      walker.each do |c|
        result << { :commit => c, :refs => refs[c.oid] }
        bail = case @limit
        when Fixnum then result.length == @limit
        when Regexp then result.last[:refs].any? { |ref| ref =~ @limit }
        when Time   then c.committer[:time] < @limit
        when Proc   then @limit.call(c)
        end
        break if bail
      end
      result
    end
    
    def to_h
      commits
    end
  end
end
