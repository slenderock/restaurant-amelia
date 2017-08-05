Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'home_page#show'
  get 'home_page/show'
  get 'reserve/show'
end
