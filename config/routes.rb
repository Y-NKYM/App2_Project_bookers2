Rails.application.routes.draw do
  get 'users/edit'
  get 'users/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'about' => 'homes#about', as: 'about'
  devise_for :users
  root to: 'homes#top'
  resources :books, only: [:create, :index, :show, :edit]
end
