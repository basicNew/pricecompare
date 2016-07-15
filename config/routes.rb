Rails.application.routes.draw do
  get 'dashboard/index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'dashboard#index'

  get 'dashboard' => 'dashboard#index'
end
