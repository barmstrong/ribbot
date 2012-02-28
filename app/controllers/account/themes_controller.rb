class Account::ThemesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_current_forum!
  load_and_authorize_resource
  
  def new
    if params[:clone].present? and t = Theme.find(params[:clone])
      @theme = t.clone
      @theme.name = "Copy of " + @theme.name
      @theme.public = false
    else
      @theme = Theme.new
    end
  end
  
  def index
    authorize! :edit, current_forum
    @themes = Theme.where(:public => true).desc('votes.point').page(params[:page])
  end
  
  def create
    @theme = Theme.new(params[:theme])
    @theme.user = current_user
    if @theme.save
      redirect_to account_theme_path(@theme), :notice => "Theme created!"
    else
      render :new
    end
  end
  
  def install
    current_forum.update_attribute :theme_id, params[:id]
    redirect_to account_themes_path, :notice => "Theme installed!"
  end
  
  def uninstall
    current_forum.update_attribute :theme_id, nil
    redirect_to account_themes_path, :notice => "Theme uninstalled!"
  end
  
  def show
  end
  
  def update
    if @theme.update_attributes(params[:theme])
      redirect_to account_theme_path(@theme), :notice => "Theme updated!"
    else
      render :edit
    end
  end
  
  def edit
  end
  
  def destroy
    @theme.destroy
    redirect_to account_themes_path, :notice => "Theme deleted."
  end

end
