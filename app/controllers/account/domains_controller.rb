class Account::DomainsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_current_forum!
  
  def show
    @forum = current_forum
    authorize! :edit, @forum
  end
  
  def update
    @forum = current_forum
    authorize! :update, @forum
    if @forum.update_attributes params[:forum]
      redirect_to account_domain_path, :notice => "Custom domain updated!"
    else
      render :show
    end
  end
end
