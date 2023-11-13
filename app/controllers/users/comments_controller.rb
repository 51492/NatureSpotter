class Users::CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    @comment.save
    flash.now[:notice] = 'コメントを投稿しました'
    # redirect_to post_path(post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    Comment.find(params[:id]).destroy
    flash.now[:alert] = 'コメントを削除しました'
    render :create
    # redirect_to post_path(post), notice: "コメントを削除しました"
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
