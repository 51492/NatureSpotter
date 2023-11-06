class ApplicationController < ActionController::Base

  # emailを確認し、ゲスト用のアドレスだった場合はtopにリダイレクト ===================
  def check_guest
    email = resource&.email || params[:user][:email].downcase
    if email == "guest@example.com"
      redirect_to root_path, alert: "ゲストユーザーの編集・削除はできません。"
    end
  end
  # ==================================================================================

end


#以下参考

  # 簡単ログイン・ゲストログイン機能の実装方法（ポートフォリオ用）
    # https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104