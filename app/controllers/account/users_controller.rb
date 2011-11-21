class Account::UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    authorize! :edit, current_forum
    @participations = current_forum.participations
      .includes(:user)
      .desc(:created_at)
      .page(params[:page])
  end

end
