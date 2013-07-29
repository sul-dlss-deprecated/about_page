module AboutPage
  module AboutHelper
    def render_about_pane key, profile
      partial = (profile.class.partial rescue nil) || key.to_s
      render :partial => partial, :locals => { :key => key, :profile => profile } 
    rescue 
      render :partial => 'exception', :locals => { :key => key, :profile => profile, :exception => $! }
    end
  end
end
