Rails.application.routes.draw do

  # 管理者側 =====================================================================
  devise_for :admins
  # ==============================================================================


  # 会員側 =======================================================================
  # namespace :users do
  #   resources :posts, only: [:show]
  # end

  scope module: :users do
    root :to => "homes#top"
    # get '/NatureSpotter' => 'users/homes#top', as: "top"
    get '/about' => 'homes#about', as: "about"
    get "search_tag" => "posts#search_tag"

    # URIが「users/:id」となりdeviseと競合するためpathオプションを用いてURIを「user/:id」で定義
    resources :users, only: [:index, :show, :edit, :update], path: "user"
    
    # コメントといいねのルートをpostのルートにネストする
    resources :posts, only: [:new, :create, :index, :show, :destroy] do
      resources :comments, only: [:create, :destroy] 
      resource :likes, only: [:create, :destroy]
    end
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


# 以下参考

  # 【Rails】いいね機能
    # https://zenn.dev/ganmo3/articles/c071ba9aecaa51