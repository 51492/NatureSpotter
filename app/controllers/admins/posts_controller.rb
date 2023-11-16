class Admins::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(12)
    @tag_list = tag_top5 # private参照
  end
  
  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = Comment.new
    @tag_list = @post.tags
    gon.post = @post
  end

  private
  
  def post_params
    params.require(:post).permit(:image, :place, :address, :caption)
  end
  
  def tag_top5
    Tag.find(Tagging.group(:tag_id).order('count(post_id) desc').limit(5).pluck(:tag_id))
  end

  # def check_admin
  #   redirect_to root_path unless current_user.admin?
  # end

end
