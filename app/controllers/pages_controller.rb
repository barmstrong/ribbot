class PagesController < ApplicationController
  before_filter :require_current_forum!
  
  def show
    @page = current_forum.pages.where(:_id =>params[:id]).first
    if @page.nil?
      redirect_to root_path(:subdomain => current_forum.subdomain), :notice => "That page is no longer available."
      return
    end
  end  
end
