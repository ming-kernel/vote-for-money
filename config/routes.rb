Vote::Application.routes.draw do

  # get "password_resets/new"
  resources :password_resets

  post "proposals/create"
  get "home/index"
  get 'game/' => 'game#index'

  resources :users

  controller :session do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  # resources :session

  get 'game/get-group-info' => 'game#get_group_info'
  post 'game/do-something/' => 'game#do_something'

  post 'proposals/accept' => 'proposals#accept'
  post 'proposals/reject' => 'proposals#reject'

  post 'users/next-round' => 'users#next_round'

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
