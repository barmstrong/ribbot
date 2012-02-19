class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)

    if user.superuser?
      can :manage, :all
    end

    can :manage, Forum do |f|
      user.admin_of?(f)
    end
    cannot :destroy, Forum do |f|
      user.admin_of?(f)
    end
    can :destroy, Forum do |f|
      user.owner_of?(f)
    end
    
    can :manage, User, :_id => user.id
    can :manage, [Comment, Participation, Post, Theme], :user_id => user.id
    can [:show, :install, :uninstall], Theme, :public => true
    
    # Admin actions
    can :destroy, Comment do |c|
      user.admin_of?(c.forum)
    end
    can :manage, Participation do |p|
      user.admin_of?(p.forum)
    end
    
    
    
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
