AboutPage::Engine.routes.draw do
  match 'health' => 'about_page/about#health'
  match ":filter" => 'about_page/about#index'
  root :to => 'about_page/about#index'
end
