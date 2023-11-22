Rails.application.routes.draw do


  # 管理者側 =====================================================================
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    # registrations: 'admins/registrations'
  }

  namespace :admins do
    resources :users, except: []
    resources :posts
    get "search_tag" => "posts#search_tag"
    get "search" => "searches#search"
  end
  # ==============================================================================


  # 会員側 =======================================================================
  scope module: :users do
    root :to => "homes#top"
    # get '/NatureSpotter' => 'users/homes#top', as: "top"
    get '/about' => 'homes#about', as: "about"
    get "search_tag" => "posts#search_tag"
    get "search" => "searches#search"
    get ":post_latitude/:post_longitude/posts", to: "posts#location", as: "location_posts", constraints: { post_latitude: /[^\/]+/, post_longitude: /[^\/]+/ }


    # URIが「users/:id」となりdeviseと競合するためpathオプションを用いてURIを「user/:id」で定義
    resources :users, only: [:index, :show, :edit, :update], path: "user" do

      # フォロー関連をusersにネストすることでURIにuser_idを持たせ、特定のユーザーに関するフォロー情報を得られる
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"

      # いいね一覧をusersにネストし、member doでidを持たせることで、どのユーザーがいいねしたのかをurlで判別できるようになる
      member do
        get :likes
      end

      # 退会
      get '/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
      patch '/users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'

    end

    # コメントといいねのルートをpostのルートにネストする
    resources :posts do
      resources :comments, only: [:create, :destroy]
      resource :likes, only: [:create, :destroy]
    end
  end

  devise_for :users, controllers: {
    sessions: "users/sessions",
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

  # 簡単ログイン・ゲストログイン機能の実装方法（ポートフォリオ用）
    # https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104

  # 【Rails】いいね機能
    # https://zenn.dev/ganmo3/articles/c071ba9aecaa51

  # 【Rails】フォロー・フォロワー機能
    # https://zenn.dev/ganmo3/articles/a3633e8f3209da