Ninetails::Engine.routes.draw do
  with_options defaults: { format: :json } do
    root 'containers#index'

    resources :projects, except: [:new, :edit] do
      post :publish, on: :member
      resources :pages, only: [:show, :create, :index]
    end

    resources :pages, only: [:show, :create, :index] do
      resources :revisions, only: [:create, :show, :index]
    end

    resources :sections, only: [:show, :index] do
      post :validate, on: :collection
    end
  end
end
