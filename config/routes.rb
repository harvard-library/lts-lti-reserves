Rails.application.routes.draw do
 
 
#  get 'courses/show'
  get 'courses/previous_select' => 'courses#previous_select' # just creates the select/options
  get 'courses/previous' => 'courses#previous'  # displays the reserves for that previous instance

  post 'courses/delete'

#  get 'reserves/show'

#  get 'reserves/edit'

#  get 'reserves/index'

#  get 'reserves/show'

  resources :courses , except: [:create, :new, :destroy, :index]
  resources :reserves

  post 'courses/reorder' => 'courses#reorder'
  post 'courses/reuse' => 'courses#reuse'
  get 'presto/:type/' => 'reserves#fetch_cite', :defaults => {:format => :json}


  mount DceLti::Engine => "/lti"
  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
