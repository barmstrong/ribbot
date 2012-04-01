class Account::PagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_current_forum!
  
  def index
    authorize! :update, current_forum
    @pages = current_forum.pages.asc(:position).page(params[:page])
  end
  
  def new
    authorize! :udpate, current_forum
    @page = Page.new
  end
  
  def edit
    authorize! :udpate, current_forum
    @page = current_forum.pages.find(params[:id])
  end
  
  def create
    authorize! :udpate, current_forum
    @page = Page.new(params[:page])
    @page.forum = current_forum
    if @page.save
      @page.move_to(1)
      redirect_to account_pages_path, :notice => "Page created!"
    else
      render :new
    end
  end
  
  def update
    authorize! :udpate, current_forum
    @page = current_forum.pages.find(params[:id])
    if @page.update_attributes(params[:page])
      redirect_to edit_account_page_path(@page), :notice => "Page saved."
    else
      render :edit
    end
  end
  
  def destroy
    authorize! :udpate, current_forum
    @page = current_forum.pages.find(params[:id])
    @dom_id = "page_#{@page.id}"
    @page.destroy
    redirect_to account_pages_path, :notice => "Page deleted."
  end
  
  def sort
    params[:page].each_with_index do |id, index|
      Page.where(:_id => id).update_all(:position => index+1)
    end
    current_forum.update_attribute :updated_at, Time.now
    render nothing: true
  end
end
