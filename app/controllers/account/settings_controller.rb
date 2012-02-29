class Account::SettingsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @forum = current_forum
    authorize! :edit, @forum
  end
  
  def update
    @forum = Forum.find(params[:id])
    authorize! :update, @forum
    if @forum.update_attributes params[:forum]
      redirect_to account_settings_path, :notice => "Settings updated!"
    else
      render :index
    end
  end
end
