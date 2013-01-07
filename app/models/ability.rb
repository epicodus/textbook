class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.author?
      can :manage, :all
    elsif user.paid?
      can :read, :all
    else
      can :read, :all, :public => true
    end
  end
end
