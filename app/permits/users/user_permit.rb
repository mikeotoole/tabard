class UserPermit < CanTango::UserPermit
  def initialize ability
    super
  end

protected
  def permit_rules
    can :manage, :all
  end
end
