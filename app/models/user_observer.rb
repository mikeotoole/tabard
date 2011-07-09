class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.welcome_email(user).deliver unless user.no_signup_email
  end
end
