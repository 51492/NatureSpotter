class Users::HomesController < ApplicationController
  def top
    @post = Post.all
    gon.post = @post.as_json #html.erb内のJSで呼び出すためにgonに格納
  end

  def about
  end
end
