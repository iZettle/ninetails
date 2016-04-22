Ninetails::Engine.routes.draw do

  concern :revisable do
    resources :revisions, only: [:create, :show, :index]
  end

  with_options defaults: { format: :json } do
    root 'containers#index'

    resources :projects, except: [:new, :edit] do
      post :publish, on: :member
    end

    scope "(/projects/:project_id)/:type", constraints: { type: /(pages|layouts)/ } do
      resources :containers, only: [:show, :create, :index], concerns: :revisable, path: "/"
    end

    resources :sections, only: [:show, :index] do
      post :validate, on: :collection
    end
  end
end
