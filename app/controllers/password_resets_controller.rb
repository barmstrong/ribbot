class PasswordResetsController < ApplicationController
  
  def create
    user = User.where(:email => params[:email].strip).first
    user.send_password_reset(current_forum) if user
    redirect_to root_url, :notice => "Email sent with password reset instructions."
  end
  
  def edit
    @user = User.where(:password_reset_token =>params[:id]).first
    
    if @user.nil?
      redirect_to root_path, :notice => "That link is no longer valid"
      return
    end
  end
  
  def update
    @user = User.where(:password_reset_token =>params[:id]).first
    
    if @user.nil?
      redirect_to root_path, :notice => "That link is no longer valid"
      return
    end
    
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Your password reset link has expired.  Please try again."
    elsif @user.update_attributes(params[:user])
      signin! @user, "Your password has been reset."
    else
      render :edit
    end
  end
end
