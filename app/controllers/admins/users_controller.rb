class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update #顧客情報アプデ
    @user = User.find(params[:id])
    # @customer.update(customer_params)
    # redirect_to customer_path
    if @user.update(customer_params)
      redirect_to admins_user_path(@user), notice: "user情報を更新しました。"
    else
      render :edit
    end
  end

  private

  # def check_admin
  #   redirect_to root_path unless current_user.admin?
  # end

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :is_withdrawal)
  end


end