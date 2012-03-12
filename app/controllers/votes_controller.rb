class VotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_current_forum!
  
  def index
    redirect_to root_path, :notice => "You'll need to enable javascript to vote"
  end
  
  def create
    voteable = params[:dom_id].to_model
    allowed = true
    
    if current_user.over_rate_limit?
      allowed = false
      @error = "You are voting too fast.  Please wait a bit."
    end
    
    if current_user.created_at > 1.week.ago and params[:direction].to_sym == :down
      allowed = false
      @error = "You need more reputation before you downvote."
    end
    
    if voteable.respond_to?(:forum) and current_user.banned_from?(voteable.forum)
      allowed = false
    end
    
    if allowed
      if params[:toggle] == 'on'
        current_user.vote(voteable, params[:direction].to_sym)
      elsif params[:toggle] == 'off'
        current_user.unvote(voteable)
      end
      voteable.update_ranking
    end
  end
end
