Rails.application.routes.draw do

  namespace :users do
    resources :posts, only: [:show]
  end
  # 管理者側 =====================================================================
  devise_for :admins
  # ==============================================================================


  # 会員側 =======================================================================
  scope module: :users do
    root :to => "homes#top"
    # get '/NatureSpotter' => 'users/homes#top', as: "top"
    get '/about' => 'homes#about', as: "about"
    
    resources :posts, except: [:show]
  end

  devise_for :users, controllers: {

    # ゲストアカウントへのdestroyメソッドを無効とするため、deviseのregistrations_controllerの参照先としてusers直下に作成したcontrollerも含める
    registrations: "users/registrations",

    # ゲストパスワードへのupdateメソッドを無効とするため、deviseのpasswords_controllerの参照先としてusers直下に作成したcontrollerも含める
    passwords: "users/passwords"

  }

  # ゲストログインのアクションに繋がるルートをdeviseのsessionsコントローラーに追加
  devise_scope :user do
    post "/users/guest_sign_in", to: "users/sessions#new_guest"
  end
  # ==============================================================================


end
