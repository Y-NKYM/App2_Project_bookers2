Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'home/about' => 'homes#about', as: 'about'
  devise_for :users
  root to: 'homes#top'
  resources :books, only: [:create, :index, :show, :edit, :update, :destroy] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update] do
    # URLにRelationshipのidが必要ないので"resource"で良い。
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings'
    get 'followers' => 'relationships#followers'
    post 'search' => 'users#search'
  end
  get 'search' => 'searches#search'
  resources :groups, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    post 'join' => 'groups#join'
    delete 'leave' => 'groups#leave'
    get 'mail' => 'groups#event_mail'
    post 'mail' => 'groups#send_mail'
  end
  get 'mail/sent' => 'groups#sent_mail'

  get 'search_tag' => 'searches#search_tag'
  resources :rooms, only: [:create, :show] do
    resources :messages, only: [:create, :destroy]
  end
end
