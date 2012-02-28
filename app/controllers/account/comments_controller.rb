class Account::CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_current_forum!
  
  def index
    @comments = Comment.where(:forum_id => current_forum.id, :user_id => current_user.id)
      .includes(:post, :user)
      .desc(:created_at)
      .page(params[:page])
  end
    
end
