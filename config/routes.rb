Ninetails::Engine.routes.draw do
  root 'pages#index'

  resources :pages, only: :show do
    resources :page_revisions, only: [:create, :show, :index], path: "revisions"
  end

  resources :sections, only: [:show, :index]
end
