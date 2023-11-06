class Users::SessionsController < Devise::SessionsController
  def new_guest
    user = User.guest
    sign_in user
    redirect_to root_path, notice: "ゲストユーザーとしてログインしました。"
  end

end


#以下参考

  # 簡単ログイン・ゲストログイン機能の実装方法（ポートフォリオ用）
    # https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104