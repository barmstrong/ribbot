class ParticipationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_subdomain!
  load_and_authorize_resource
  
  def ban
    #@participation = Participation.find(params[:id])
    @participation.update_attribute :banned, true
  end
  
  def unban
    #@participation = Participation.find(params[:id])
    @participation.update_attribute :banned, false
    render :ban
  end
end
