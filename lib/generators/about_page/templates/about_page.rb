AboutPage.configure do |config|
  config.app = { :name => 'Application Name', :version => '0.0.0' }

  config.dependencies = AboutPage::Dependencies.new

  config.environment = AboutPage::Environment.new({ 
    'Ruby' => /^(RUBY|GEM_|rvm)/
  })

  config.request = AboutPage::RequestEnvironment.new({
    'HTTP Server' => /^(SERVER_|POW_)/,
    'WebAuth' => /^WEBAUTH_/
  })
end
