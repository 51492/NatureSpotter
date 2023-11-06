class Users::PasswordsController < Devise::PasswordsController
  before_action :check_guest, only: :create
  # createアクションの実行前にapplication_controller.rb内に記載しているcheck_guestメソッドを実行させる
end