class PostsController < ApplicationController

  respond_to :html

  def index
    authorize! :view, Post
    @posts = Post.includes(:user, comments: :user).order(created_at: :desc).page(params[:page])
    respond_with @posts
  end

  def show
    authorize! :view, Post 
    @post = Post.find(params[:id])
    respond_with @post 
  end
  
  def new
    authorize! :create, Post
    @post = Post.new
    respond_with @post
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :edit, @post
    respond_with @post 
  end

  def create
    authorize! :create, Post
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to posts_path(page: params[:page])
    else
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    authorize! :edit, @post 
    if @post.update_attributes(post_params)
      redirect_to posts_path(page: params[:page])
    else
      render :edit 
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize! :destroy, @post
    @post.destroy
    redirect_to posts_path(page: params[:page])
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :title, :body)
  end

end
