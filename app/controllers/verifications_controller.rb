class VerificationsController < ApplicationController
  #before_filter :authenticate_user!, :only => :index

  def index
    if current_user.nil?
      redirect_to signin_path, :notice => "Please sign in first."
    end
  end

  def create
    current_user.send_verification_email
    redirect_to verifications_path, :notice => "Verification email sent!"
  end

  def show
    if params[:id].present? and user = User.where(:verification_token => params[:id]).first
      if !user.verified?
        user.verified_at = Time.zone.now
        user.save!
      end
      path = forums_path
      if current_user and p = current_user.participations.first
        path = root_url(:subdomain => p.forum.subdomain)
      end
      redirect_to path, :notice => "Your account has been verified!"    
    else
      redirect_to verifications_path, :notice => "Couldn't find that verification code.  Please resend a new one."
    end
  end
end
