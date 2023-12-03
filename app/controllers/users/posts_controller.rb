class Users::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    tag_list = params[:post][:tag].gsub(/[[:space:]]/, '').split(",") # paramsで受け取った値を「,」で区切ってハッシュにし、スペースを空白と同じ扱いとする

    if post_params[:image].present?
      result = Vision.image_analysis(post_params[:image])
      if result
        if @post.save
          @post.save_tags(tag_list)
          redirect_to post_path(@post), notice:"投稿が完了しました"
        else
          flash.now[:alert] = "投稿に失敗しました"
          render :new, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "不適切なコンテンツは投稿できません"
        render :new, status: :unprocessable_entity
      end
    elsif @post.save
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice:"投稿が完了しました"
    else
      flash.now[:alert] = '投稿に失敗しました'
      render :new, status: :unprocessable_entity
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

    tag_list = params[:post][:tag].gsub(/[[:space:]]/, '').split(",") # paramsで受け取った値を「,」で区切ってハッシュにし、スペースを空白と同じ扱いとする

    if post_params[:image].present?
      result = Vision.image_analysis(post_params[:image])
      if result
        if @post.update(post_params)
          redirect_to post_path(@post), notice: "投稿編集が完了しました"
        else
          flash.now[:alert] = '投稿編集に失敗しました'
          render :edit, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "不適切なコンテンツは投稿できません"
        render :edit, status: :unprocessable_entity
      end

    elsif @post.update(post_params)
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice: "投稿編集が完了しました"
    else
      flash.now[:alert] = '投稿編集に失敗しました'
      render :edit, status: :unprocessable_entity
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

  def location
    @location_lat = params[:post_latitude]
    @location_lon = params[:post_longitude]
    if params[:post_latitude].present? && params[:post_longitude].present?
      @posts = Post.where(post_latitude: params[:post_latitude], post_longitude: params[:post_longitude]).all.order(created_at: :desc).page(params[:page]).per(12)
    end
  end

  private

  def post_params
    params.require(:post).permit(:image, :place, :address, :caption, :post_latitude, :post_longitude)
  end

  # tag_listの表示において、tagの数順でTop5を表示するためのメソッド
  def tag_top5
    Tag.find(Tagging.group(:tag_id).order('count(post_id) desc').limit(5).pluck(:tag_id))
  end

end

# 以下参考

  # [Rails]タグ一覧での投稿数が多い順に並べる
    # https://qiita.com/nmwkhl/items/daa49562b9c7d9d7e0b5
