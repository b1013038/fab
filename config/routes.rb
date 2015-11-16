Rails.application.routes.draw do
  root :to => 'pic#index'

  get 'show/:userid/:id/:title' => 'pic#show'

  get 'show/:userid/' => 'pic#img_show'

  get 'login' => 'pic#login'

  get 'register' => 'pic#register'

  get 'forgotpassword' => 'pic#forgot'

#  get 'download' => 'pic#download'

  get 'convert' => 'pic#convert'

#  get ':userid/download/:id' => 'pic#download'

  get 'download/:userid/:id' => 'pic#download'

  get 'logoutuser' => 'pic#logout_user'

#  get 'pic/icon' => 'pic#icon'

  post 'forgot' => 'pic#forgot_passwd'

  post 'addpic' => 'pic#create'

  post 'adduser' => 'pic#add_user'

  get 'authuser' => 'pic#auth_user'

  post 'loginuser' => 'pic#login_user'

#test routes

#  post 'pic/index' => 'pic#show'


  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

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
