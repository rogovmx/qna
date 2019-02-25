Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  
  resources :questions do
    resources :answers, only: [:create, :update, :destroy], shallow: true do
      patch 'set_best', on: :member
    end
  end
end
