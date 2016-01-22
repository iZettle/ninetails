Ninetails::Engine.routes.draw do
  with_options defaults: { format: :json } do
    root 'pages#index'

    resources :projects

    resources :pages, only: [:show, :create, :index] do
      resources :page_revisions, only: [:create, :show, :index], path: "revisions"
    end

    resources :sections, only: [:show, :index] do
      post :validate, on: :collection
    end
  end
end
