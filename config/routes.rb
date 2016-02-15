Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  namespace :admin do
    get '/join_requests', to: 'dashboard#join_requests'
    post '/join_requests/approve', to: 'dashboard#approve_member'
    get '/certificates', to: 'dashboard#display_passed_users'
  end

  namespace :admin do
    get 'dashboard/index'
  end

  resources :courses do
    member do
      get :quiz
      post :quiz

      get '/quiz/results', to: 'courses#results'

      post :register
    end
  end

  authenticated :user do
      root :to => redirect('/courses'), as: :authenticated_root
  end

  root :to => redirect('/users/sign_in')
end
