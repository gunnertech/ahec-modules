Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  namespace :users do
    get '/passed_courses', to: 'user_membership#get_passed_courses_certificates'
  end

  namespace :admin do
    get '/join_requests', to: 'dashboard#join_requests'
    post '/join_requests/approve', to: 'dashboard#approve_member'
    get '/certificates', to: 'dashboard#display_passed_users'
    get '/demographics', to: 'dashboard#demographics'
    get '/user_reset', to: 'dashboard#reset_user'
    post '/user_reset/attempts', to: 'dashboard#reset_user_attempts'
  end

  namespace :admin do
    get 'dashboard/index'
  end

  resources :courses do
    member do
      post '/quiz', to: 'courses#grade_quiz'
      post '/time_spent', to: 'courses#time_spent_update'

      get :quiz
      get '/quiz/results', to: 'courses#results'
      get '/certificate', to: 'courses#display_certificate'

      post :register
    end
  end

  authenticated :user do
      root :to => redirect('/courses'), as: :authenticated_root
  end

  root :to => 'application#index'#redirect('/users/sign_in')
end
