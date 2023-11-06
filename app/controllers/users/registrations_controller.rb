class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: %i[update destroy]
  # destroyアクションの実行前にapplication_controller.rb内に記載しているcheck_guestメソッドを実行させる
end