class Users::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to request.referer
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "user情報を更新しました。"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :profile_image, :is_withdrawal)
  end
end
