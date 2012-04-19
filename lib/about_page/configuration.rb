module AboutPage
  Configuration = Struct.new(:app_name, :app_version, :solr, :fedora, :environment_sections).new
  
  Configuration.environment_sections = { 
    'Ruby' => /^(RUBY|GEM_|rvm)/,
    'HTTP Server' => /^(SERVER_|POW_)/,
    'WebAuth' => /^WEBAUTH_/
  }
end