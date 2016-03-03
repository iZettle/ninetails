Ninetails::Engine.routes.draw do
  with_options defaults: { format: :json } do
    root 'pages#index'

    resources :projects, only: [:create, :show, :update, :index, :destroy] do
      post :publish, on: :member
      resources :pages, only: [:show, :create, :index]
    end

    resources :pages, only: [:show, :create, :index] do
      resources :page_revisions, only: [:create, :show, :index], path: "revisions"
    end

    resources :sections, only: [:show, :index] do
      post :validate, on: :collection
    end
  end
end
