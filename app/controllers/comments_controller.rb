class CommentsController < ApplicationController

  respond_to :js 

  def edit
    @comment = Comment.find(params[:id])
    authorize! :edit, @comment
    respond_with @comment
  end

  def create
    authorize! :create, Comment
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    respond_with @comment
  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :edit, @comment 
    @comment.update_attributes(comment_params)
    respond_with @comment 
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @comment.destroy
    respond_with @comment 
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :post_id, :body)
  end

end
