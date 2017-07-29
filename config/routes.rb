Rails.application.routes.draw do
  root 'home_page#show'
  get 'home_page/show'
end
