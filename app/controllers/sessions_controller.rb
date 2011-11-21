class SessionsController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    user = User.first(conditions: {email: params[:email]})
    if user && user.authenticate(params[:password])
      signin! user
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    signout!
  end

end
