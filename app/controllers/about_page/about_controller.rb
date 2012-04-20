module AboutPage
  class AboutController < ApplicationController
    def index
      env = Bundler.load
      groups = env.current_dependencies.group_by { |d| d.groups.first.to_s }
      @dependencies = Hash[groups.collect { |group,deps| [group,Hash[deps.collect { |dep| [dep.name,dependency_hash(env, dep.name)] }]] }]
      
      @solr_profile = Configuration.solr.nil? ? {} : Configuration.solr.luke(:show => 'schema', :numTerms => 0)['index']
      @fedora_profile = Configuration.fedora.nil? ? {} : Configuration.fedora.profile
      
      respond_to do |format|
        format.html # about_page.html.erb
        format.json { render :json => { :dependencies => @dependencies, :environment => AboutPage::Configuration::Environment, :solr => @solr_profile, :fedora => @fedora_profile } }
        format.xml  { render :xml  => { :dependencies => @dependencies, :environment => AboutPage::Configuration::Environment, :solr => @solr_profile, :fedora => @fedora_profile } }
      end
    end

    private
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
