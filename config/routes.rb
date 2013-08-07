AboutPage::Engine.routes.draw do
  match 'health' => 'about_page/about#health'
  match ":filter" => 'about_page/about#index', :as => 'component'
  root :to => 'about_page/about#index'
end
