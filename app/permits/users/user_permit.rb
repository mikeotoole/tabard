class UserPermit < CanTango::UserPermit
  def initialize ability
    super
  end

protected
  def static_rules
    can :view, UserProfile
    can :manage, User do |some_user|
      some_user.id == user.id
    end
    can :manage, UserProfile do |profile|
      profile.user == user
    end
  end
  def dynamic_rules
  	can :manage, :all
  end
end
