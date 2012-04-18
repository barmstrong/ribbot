class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => :password_reset
  before_filter :require_current_forum!, :only => :show
  
  def new
    @title = "Create a Forum"
    @user = User.new
    @forum = Forum.new
  end

  def create
    @user = User.new(params[:user])
    @user.password = params[:user][:password]
    if @user.save
      signin! @user, "Thanks for creating an account!"
    else
      try_login or render 'sessions/new'
    end
  end
  
  def create_with_forum
    @user = User.new(params[:user])
    @user.password = params[:user][:password]
    @forum = Forum.new(:subdomain => params[:subdomain])
    
    if @user.valid? and @forum.valid?
      @user.save!
      @forum.save!
      @forum.add_owner(@user)
      signin! @user, "Thanks for creating an account!"
    else
      try_login or render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
    raise CanCan::AccessDenied.new("Not authorized!", :view, User) unless @user.member_of?(current_forum)
    participations = @user.participations.owner
    @forums = Forum.where(:_id.in => participations.collect{|p| p.forum_id}).asc(:name)
  end
  
  def password_reset
    @user = current_user
    if @user.authenticate(params[:old_password])
      if params[:password] == params[:password_confirmation]
        @user.password = params[:password]
        if @user.save
          redirect_to account_profile_path, :notice => "Password updated!"
        else
          redirect_to account_profile_path, :notice => @user.errors.full_messages.join(" ")
        end
      else
        redirect_to account_profile_path, :notice => "New password didn't match confirmation"
      end
    else
      redirect_to account_profile_path, :notice => "Old password didn't match"
    end
  end
  
  protected
  
  def try_login
    if user = User.first(conditions: {email: @user.email}) and user.authenticate(params[:user][:password])
      signin! user
      true
    else
      false
    end
  end

end
