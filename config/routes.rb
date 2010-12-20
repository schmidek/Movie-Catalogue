Site::Application.routes.draw do
  get "tmdb/search"

  get "tmdb/getInfo"

  resources :user_sessions do
    collection do
      get 'create_api'
    end
  end
  resources :users
  
  resources :catalogues do
    member do
		get 'new_revisions'
		get 'changes'
		get 'grid'
    end
	resources :movies do
		collection do
			post 'update_many'
		end
	end
  end

  root :to => "users#show"
  match "logout" => "user_sessions#destroy"
  match "login" => "user_sessions#new"

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end


end
