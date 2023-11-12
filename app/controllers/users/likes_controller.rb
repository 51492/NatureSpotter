class Users::LikesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    like = current_user.likes.new(post_id: @post.id)
    like.save
    # redirect_to request.referer ←redirect先を消すことでコントローラー側がjsファイルを探す
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = current_user.likes.find_by(post_id: @post.id)
    like.destroy
    # redirect_to request.referer ←redirect先を消すことでコントローラー側がjsファイルを探す
  end

end

# 以下参考

  # 【Rails】いいね機能
    # https://zenn.dev/ganmo3/articles/c071ba9aecaa51