class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: %i[update destroy]
  # destroyアクションの実行前にapplication_controller.rb内に記載しているcheck_guestメソッドを実行させる
end


#以下参考

  # 簡単ログイン・ゲストログイン機能の実装方法（ポートフォリオ用）
    # https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104