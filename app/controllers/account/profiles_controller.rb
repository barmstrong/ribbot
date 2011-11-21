class Account::ProfilesController < ApplicationController
  before_filter :authenticate_user!
  
  def show
  end
  
  def update
    @user = current_user
    authorize! :edit, @user
    
    if @user.update_attributes(params[:user])
      redirect_to account_profile_path, :notice => "Profile updated!"
    else
      render :show
    end
  end
end
