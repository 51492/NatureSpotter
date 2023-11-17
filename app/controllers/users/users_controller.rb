class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest, only: %i[update destroy]

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
  
  def withdrawal
    @user = User.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_withdrawal: true)
    reset_session
    flash[:notice] = "退会処理を実行しました。"
    redirect_to root_path
  end

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(10)
  end
  # 退会ステータス実装後、.allを.where(is_deleted: false)に変更

  def likes
    @user = User.find(params[:id])
    likes = Like.where(user_id: @user.id).pluck(:post_id)
    @like_posts = Post.find(likes)
    # @post = Post.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :profile_image, :is_withdrawal, :introduction)
  end

  def check_guest
    if current_user.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの編集・削除はできません。'
    end
  end
end
