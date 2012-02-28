class ParticipationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_current_forum!, :except => :hide
  load_and_authorize_resource
  
  def ban
    @participation.update_attribute :banned, true
  end
  
  def unban
    @participation.update_attribute :banned, false
    render :ban
  end
  
  def hide
    if @participation.level == Participation::MEMBER
      p 2
      @participation.update_attribute :hidden, true
    end
    redirect_to forums_path
  end
end
