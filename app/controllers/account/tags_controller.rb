class Account::TagsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_current_forum!
  
  def index
    authorize! :edit, current_forum
    @tag = Tag.new
    @tags = current_forum.tags.asc(:position).page(params[:page])
  end
  
  def create
    authorize! :udpate, current_forum
    @tag = Tag.new(params[:tag])
    @tag.forum = current_forum
    @tag.save
    @tag.move_to(1)
  end
  
  def update
    authorize! :udpate, current_forum
    @tag = current_forum.tags.find(params[:id])
    @tag.update_attributes(params[:tag])
  end
  
  def destroy
    authorize! :udpate, current_forum
    @tag = current_forum.tags.find(params[:id])
    @dom_id = "tag_#{@tag.id}"
    @tag.destroy
  end
  
  def sort
    params[:tag].each_with_index do |id, index|
      Tag.where(:_id => id).update_all(:position => index+1)
    end
    render nothing: true
  end
end
