AboutPage::Engine.routes.draw do
  match ":filter" => 'about_page/about#index'
  root :to => 'about_page/about#index'
end
