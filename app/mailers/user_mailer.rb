class UserMailer < ActionMailer::Base
  default :from => "noreply@crumblin.com"

  def password_reset(user, password)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin Password Reset Notification', :tag => 'password-reset', :content_type => "text/html") do |format|
       format.html { render "devise/mailer/reset_password_by_admin_instructions" }
    end        
  end
  
  def all_password_reset(user, password)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin Password Reset Notification', :tag => 'password-reset', :content_type => "text/html") do |format|
       format.html { render "devise/mailer/reset_all_password_by_admin_instructions" }
    end        
  end

  def setup_admin(user, password)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin Password Reset Notification', :tag => 'password-reset', :content_type => "text/html") do |format|
       format.html { render "devise/mailer/new_admin_user_setup_instructions" }
    end        
  end
end