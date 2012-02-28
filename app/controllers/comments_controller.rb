class CommentsController < ApplicationController
  before_filter :require_current_forum!
  before_filter :authenticate_user!
  before_filter :load_params
  
  def load_params
    @post = current_forum.posts.find(params[:post_id])
    @comment = @post.comments.find(params[:id]) if params[:id].present?
  end
  
  def create
    @comment = @post.comments.new(params[:comment])
    @comment.forum = current_forum
    @comment.user = current_user
    @comment.parent = @post.comments.find(params[:comment][:parent_id]) unless params[:comment][:parent_id].blank?
    
    respond_to do |format|
      format.html do
        if @comment.save
          redirect_to post_path(@comment.post), :notice => "Comment posted!"
        else
          redirect_to post_path(@comment.post)
        end
      end
      format.js
    end
  end
  
  def update
    authorize! :update, @comment
    if @comment.update_attributes(params[:comment])
      redirect_to post_path(@post), :notice => "Updated!"
    else
      render :edit
    end
  end
  
  def edit
    authorize! :edit, @comment
  end
  
  def destroy
    if @comment.children.empty? or current_user.admin_of?(@comment.forum)
      @comment.destroy
    else
      @comment.update_attribute :deleted, true
    end
    redirect_to @post, :notice => "#{current_forum.comment_label} deleted"
  end
end
