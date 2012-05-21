module AboutPage
  module AboutHelper
    def render_about_pane key, profile
      render :partial => partial_for_about_key(key), :locals => { :key => key, :profile => profile } 
    rescue 
      render :partial => 'exception', :locals => { :key => key, :profile => profile, :exception => $! }
    end

    def partial_for_about_key key
      about_page_partials[key] || key.to_s
    end

    private

    def about_page_partials
      { :solr => 'generic_hash', :fedora => 'generic_hash', :request => 'environment' }
    end
  end
end
