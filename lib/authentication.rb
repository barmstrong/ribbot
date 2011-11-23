module Authentication
  def signin! user, notice = "Welcome back #{user.name}!"
    session[:user_id] = user.id
    path = verifications_path
    if user.verified?
      path = current_forum ? root_path : forums_path
    end
    redirect_to path, :notice => notice
  end
  
  def signout!
    session[:user_id] = nil
    redirect_to root_path, :notice => "You are now signed out"
  end
  
  def current_user
    @current_user ||= User.where(:_id => session[:user_id]).first if session[:user_id]
  end
  
  def signed_in?
    current_user.present?
  end
  
  def authenticate_user!
    if current_user.nil?
      redirect_to signin_path, :notice => "Please sign in first to access this page."
      false
    else
      if current_user.verified?
        true
      else
        redirect_to verifications_path
        false
      end
    end
  end
  
  def authenticate_superuser!
    if authenticate_user!
      if current_user.superuser?
        true
      else
        redirect_to signin_path
      end
    end
    false
  end
  
  # makes some methods available in views
  def self.included(base)
    base.helper_method :current_user, :signed_in? if base.respond_to? :helper_method
  end
  
end