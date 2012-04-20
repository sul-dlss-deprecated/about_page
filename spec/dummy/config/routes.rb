Rails.application.routes.draw do

  mount AboutPage::Engine => "/about(.:format)"
end
