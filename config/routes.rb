AboutPage::Engine.routes.draw do
  match 'health', to: 'about_page/about#health', via: :get
  match ":filter", to: 'about_page/about#index', :as => 'component', via: :get
  root :to => 'about_page/about#index'
end
