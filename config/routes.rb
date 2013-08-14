Vote::Application.routes.draw do


  get 'admin/' => 'admin#index'
  get 'admin/show_users' => 'admin#show_users'
  get 'admin/show_groups' => 'admin#show_groups'
  get 'admin/show_proposals' => 'admin#show_proposals'
  get "admin/assign_users" => 'admin#assign_users'
  get "admin/assign_penalty" => 'admin#assign_penalty'
  get "admin/delete_users" => 'admin#delete_users'
  get "admin/stop_game" => 'admin#stop_game'
  get "admin/resume_game" => 'admin#resume_game'

  post "proposals/create"

    

  resources :users
  get "users/delete/:id" => 'users#delete'

  controller :session do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end


  get 'game/get-group-info' => 'game#get_group_info'
  post 'proposals/accept' => 'proposals#accept'
  post 'users/next-round' => 'users#next_round'

  scope '(:locale)' do
    get "home/index"
    controller :session do
      get 'login' => :new
      post 'login' => :create
      get 'logout' => :destroy
    end
    get 'game/' => 'game#index'
    root :to => 'home#index'    
  end  


end
