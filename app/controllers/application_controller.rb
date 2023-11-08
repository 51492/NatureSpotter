class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end


  # emailを確認し、ゲスト用のアドレスだった場合はtopにリダイレクト ===================
  def check_guest
    email = resource&.email || params[:user][:email].downcase
    if email == "guest@example.com"
      redirect_to root_path, alert: "ゲストユーザーの編集・削除はできません。"
    end
  end
  # ==================================================================================

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end


#以下参考

  # 簡単ログイン・ゲストログイン機能の実装方法（ポートフォリオ用）
    # https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104