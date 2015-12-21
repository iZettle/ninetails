Ninetails::Engine.routes.draw do
  with_options defaults: { format: :json } do
    root 'pages#index'

    resources :pages, only: [:show, :create, :index] do
      resources :page_revisions, only: [:create, :show, :index], path: "revisions"
    end

    resources :sections, only: [:show, :index]
  end
end
