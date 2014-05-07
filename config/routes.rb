AboutPage::Engine.routes.draw do
  match 'health' => 'about_page/about#health', via: :all
  match ":filter" => 'about_page/about#index', :as => 'component', via: :all
  root :to => 'about_page/about#index'
end
