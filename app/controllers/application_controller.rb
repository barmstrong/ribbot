class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  include Authentication
  
  before_filter :check_subdomain
  
  def check_subdomain
    if Rails.env.production? and request.host.downcase =~ /^www|ribbot\.heroku\.com/
      redirect_to request.protocol + 'ribbot.com' + request.fullpath, :status => 301
    end
  end
  
  def current_forum
    @current_forum ||= request.subdomain.present? ? Forum.where(:subdomain => request.subdomain.downcase).first : nil
  end
  helper_method :current_forum
  
  def require_subdomain!
    if current_forum.nil?
      redirect_to forums_url(:subdomain => false)
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
