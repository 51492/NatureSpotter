class Users::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    tag_list = params[:post][:tag].split(",") # paramsで受け取った値を「,」で区切ってハッシュにする

    if @post.save
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice:"投稿完了"
    else
      render :new
    end
  end

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

  def edit
    @post = Post.find(params[:id])
    if @post.user != current_user
      redirect_to posts_path
    end
  end

  def update
    @post = Post.find(params[:id])
    
    tag_list = params[:post][:tag].split(",") # paramsで受け取った値を「,」で区切ってハッシュにする
    
    if @post.update(post_params)
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice: "投稿編集完了"
    else
      render "edit"
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  def search_tag
    @tag_list = tag_top5 # private参照
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.all.order(created_at: :desc).page(params[:page]).per(12)
  end


  private

  def post_params
    params.require(:post).permit(:image, :place, :address, :caption)
  end
  
  # tag_listの表示において、tagの数順でTop5を表示するためのメソッド
  def tag_top5
    Tag.find(Tagging.group(:tag_id).order('count(post_id) desc').limit(5).pluck(:tag_id))
  end

end

# 以下参考

  # [Rails]タグ一覧での投稿数が多い順に並べる
    # https://qiita.com/nmwkhl/items/daa49562b9c7d9d7e0b5
