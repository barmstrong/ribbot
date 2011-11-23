class Superuser::ForumsController < ApplicationController
  before_filter :authenticate_superuser!
  
  def index
    @forums = Forum.desc(:created_at).page(params[:page])
  end

end
