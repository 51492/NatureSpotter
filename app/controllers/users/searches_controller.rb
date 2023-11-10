class Users::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(params[:method], params[:word])
    
    elsif (params[:word])[0] == "#"
      @posts = Tag.search(params[:word]).order(created_at: :desc)
    else
      @posts = Post.looks(params[:method], params[:word])
    end
  end
end