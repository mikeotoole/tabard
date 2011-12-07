###
# Helpers
###

# Create user
def create_user(first_name, last_name)
  puts "Creating #{first_name} #{last_name}"
  user = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "#{first_name}@#{last_name}.com", :password => "Password",
      :user_profile_attributes => {:first_name => first_name, :last_name => last_name, :display_name => "#{first_name} #{last_name}"},
      :date_of_birth => 22.years.ago.to_date)
  user.skip_confirmation!
  user.save!
end

unless @dont_run

  ###
  # Create Admin Users
  ###
  puts "Creating test active admin users"
  superadmin = AdminUser.create(:email => 'superadmin@example.com', :password => 'Password', :password_confirmation => 'Password', :role => "superadmin")
  moderator = AdminUser.create(:email => 'moderator@example.com', :password => 'Password', :password_confirmation => 'Password', :role => "moderator")
  admin = AdminUser.create(:email => 'admin@example.com', :password => 'Password', :password_confirmation => 'Password', :role => "admin")
  
  ###
  # Create Regular Users
  ###
  USER_NAMES = [%w(Robo Billy), %w(Diabolical Moose), %w(Snappy Turtle), %w(Dirty Badger), %w(Sleepy Pidgeon), %w(Apathetic Tiger), %w(Fuzzy Crab),
                %w(Sad Panda), %w(Kinky Fox)]
  
  puts "Time: 2 months ago"
  Timecop.freeze(2.months.ago)
  
  USER_NAMES.each do |user|
    create_user(user[0], user[1])
  end
  
  UserProfile.find_by_last_name("Billy").user.update_attribute(:email, "billy@robo.com")
  
  puts "Removing Panda accepted documents"
  s_panda = UserProfile.find_by_last_name("Panda")
  s_panda.user.update_attribute(:accepted_current_terms_of_service, false)
  s_panda.user.update_attribute(:accepted_current_privacy_policy, false)
  s_panda.user.accepted_documents.destroy_all
  
  puts "Creating a user for Mike, because he thinks our adjective animals aren't cool enough..."
  mike = User.new(:accepted_current_terms_of_service => true, 
                  :accepted_current_privacy_policy => true,
                  :email => "mpotoole@gmail.com", 
                  :password => "Password",
                  :date_of_birth => Date.new(1980,4,17),
                  :user_profile_attributes => {:first_name => "Mike", :last_name => "O'Toole", :display_name => "Subfighter13"})
  mike.skip_confirmation!
  mike.save

end  