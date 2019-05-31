Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    resources :readings, only: %i[create show]
    scope 'thermostats/' do
      get :statistics, to: 'thermostats#statistics'
    end
    post :authenticate, to: 'authentication#authenticate'
  end

end
