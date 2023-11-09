class Users::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(params[:method], params[:word])
    else
      @posts = Post.looks(params[:method], params[:word])
    end
  end
end