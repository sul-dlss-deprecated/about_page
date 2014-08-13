require 'grit'

module AboutPage
  class GitLog  < AboutPage::Configuration::Node
    attr_reader :commits
    
    def initialize(opts = {})
      root  = opts.fetch(:root, Rails.root)
      @limit = opts.fetch(:limit, %r{/tags/})
      @repo = Grit::Repo.new(root)
    end
    
    def commits
      refs = @repo.refs_list.inject(Hash.new { |h,k| h[k] = [] }) { |h,r| h[r[1]] << r[0]; h }
      @repo.log(@repo.head.name).inject([]) do |a,c|
        a << { :commit => c.to_hash, :refs => refs[c.sha] }
        bail = case @limit
        when Fixnum then a.length == @limit
        when Regexp then a.last[:refs].any? { |ref| ref =~ @limit }
        when Time   then c.committed_date < @limit
        when Proc   then @limit.call(c)
        end
        if bail then break(a) else a end
      end
    end
    
    def to_h
      commits
    end
  end
end
