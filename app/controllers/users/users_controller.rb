class Users::UsersController < ApplicationController
  def edit
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
  end


  private

  def user_params
    params.require(:user).permit(:email, :name, :profile_image, :is_withdrawal)
  end
end
