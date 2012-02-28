class ForumsController < ApplicationController
  before_filter :require_current_forum!, :only => :show
  before_filter :authenticate_user!, :except => :show
  
  def new
    @forum = Forum.new
  end
  
  def index
    @participations = current_user.participations.includes(:forum).where(:hidden => false).asc(:level)
  end
  
  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      @forum.add_owner(current_user)
      redirect_to root_url(:subdomain => @forum.subdomain), :notice => "Forum created!"
    else
      render :new
    end
  end
  
  def destroy
    @forum = Forum.find(params[:id])
    authorize! :destroy, @forum
    @forum.destroy
    redirect_to forums_path, :notice => "Forum deleted."
  end
  
end
