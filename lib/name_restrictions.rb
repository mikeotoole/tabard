module NameRestrictions
  # List of invalid community names (subdomains). These should all be LOWERCASE.
  INVALID_NAMES = %w(www, account, blog, secure, login, logout, admin, manage, management, my, myaccount, mobile,
                  m, crumblin, digitalaugment, digitalaugmentinc, da)

  def self.name_set
    INVALID_NAMES.to_set
  end
end