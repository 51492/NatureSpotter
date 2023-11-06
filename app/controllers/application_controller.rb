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
