Ninetails::Engine.routes.draw do

  concern :revisable do
    resources :revisions, only: [:create, :show, :index]
  end

  with_options defaults: { format: :json } do
    root 'containers#index'

    resources :folders, only: [:index]

    resources :projects, except: [:new, :edit] do
      post :publish, on: :member
    end

    scope "(/projects/:project_id)/:type", constraints: { type: /(pages|layouts)/ } do
      resources :containers, except: [:new, :edit, :update], concerns: :revisable, path: "/"
    end

    resources :containers, only: [] do
      get "/projects", to: "project_containers#projects"
    end

    resources :sections, only: [:show, :index] do
      post :validate, on: :collection
    end
  end
end
