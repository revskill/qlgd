Qlgd::Application.routes.draw do
  require 'sidekiq/web'
# ...
  mount Sidekiq::Web, at: '/sidekiq'
  devise_for :users
  get "/" => "dashboard#index"
  get '/active' => 'dashboard#monitor'
  get "calendar" => "dashboard#calendar", :as => :calendar
  get "about" => "static_pages#about"
  get "/lich/:id" => "dashboard#show", :as => :lich
  get "/lop/:id" => "dashboard#lop"  
  #get '/' => 'static_pages#home'
  get "lich/:lich_id/attendances" => "attendances#index"
  post "lich/:lich_id/attendances" => "attendances#update"
  get "lich/:lich_id/noidung" => 'attendances#getnoidung'
  post "lich/noidung" => "attendances#noidung"
  post "lich/:lich_id/settinglop" => "attendances#settinglop"
  

  get "lops" => "lop_mon_hocs#index"
  get "lop/:lop_id/info" => "lop_mon_hocs#info"
  get "lop/:id/show" => "lop_mon_hocs#show"
  post "lop/settinglop" => "lop_mon_hocs#update"  

  get 'lop/:id/assignments' => "assignments#index"
  post 'lop/:id/assignments' => "assignments#create"
  post 'lop/:id/reorder_assignments' => "assignments#reorder"
  put 'lop/:id/assignments' => 'assignments#update'
  delete 'lop/:id/assignments' => "assignments#delete"

  post 'lop/:id/assignment_groups' => "assignment_groups#create"
  delete 'lop/:id/assignment_groups' => "assignment_groups#delete"
  put 'lop/:id/assignment_groups' => 'assignment_groups#update'  
  post 'lop/:id/reorder_assignment_groups' => 'assignment_groups#reorder'

  get '/lop/:id/submissions' => 'submissions#index'
  post '/lop/:id/submissions' => 'submissions#update'

  get "lich/:lich_id/info" => "lich_trinh_giang_days#info"
  get '/lop/:lop_id/:giang_vien_id/lich_trinh_giang_days' => 'lich_trinh_giang_days#index'
  get '/lop/:lop_id/:giang_vien_id/lich_trinh_giang_days/bosung' => 'lich_trinh_giang_days#index_bosung'
  post '/lop/:lop_id/lich_trinh_giang_days/create_bosung' => 'lich_trinh_giang_days#create_bosung'
  put '/lop/:lop_id/lich_trinh_giang_days/update_bosung' => 'lich_trinh_giang_days#update_bosung'
  delete '/lop/:lop_id/lich_trinh_giang_days/remove_bosung' => 'lich_trinh_giang_days#remove_bosung'
  post '/lop/:lop_id/lich_trinh_giang_days/restore_bosung' => 'lich_trinh_giang_days#restore_bosung'
  post '/lop/:lop_id/lich_trinh_giang_days/nghiday' => 'lich_trinh_giang_days#nghiday'
  post '/lop/:lop_id/lich_trinh_giang_days/unnghiday' => 'lich_trinh_giang_days#unnghiday'
  post '/lop/:lop_id/lich_trinh_giang_days/complete' => 'lich_trinh_giang_days#complete'
  post '/lop/:lop_id/lich_trinh_giang_days/uncomplete' => 'lich_trinh_giang_days#uncomplete'
  post '/lop/:lop_id/lich_trinh_giang_days/accept' => 'lich_trinh_giang_days#accept'
  post '/lop/:lop_id/lich_trinh_giang_days/remove' => 'lich_trinh_giang_days#remove'
  post '/lop/:lop_id/lich_trinh_giang_days/restore' => 'lich_trinh_giang_days#restore'
  post '/lop/:lop_id/lich_trinh_giang_days/update' => 'lich_trinh_giang_days#update'
  post '/lop/:lop_id/lich_trinh_giang_days/capnhat' => 'lich_trinh_giang_days#capnhat'
  get '/lop/:lop_id/:giang_vien/lich_trinh_giang_days/content' => 'lich_trinh_giang_days#getcontent'
  post '/lop/:lop_id/lich_trinh_giang_days/content' => 'lich_trinh_giang_days#content'
  get '/lich_trinh_giang_days' => 'lich_trinh_giang_days#home'
  get '/monitor' => 'lich_trinh_giang_days#monitor'
  resources :tenants do 
    resources :giang_viens
    resources :sinh_viens
    resources :users
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'dashboard#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
