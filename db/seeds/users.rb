###
# Helpers
###

# Create user
def create_user(first_name, last_name)
  puts "Creating #{first_name} #{last_name}"
  user = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "#{first_name.downcase}#{last_name.downcase}@digitalaugment.com", :password => "Password",
      :time_zone => "Pacific Time (US & Canada)",
      :user_profile_attributes => {:first_name => first_name, :last_name => last_name, :display_name => "#{first_name} #{last_name}"},
      :date_of_birth => 22.years.ago.to_date,
      :beta_code => "Chuck Norris")
  user.skip_confirmation!
  user.save!
end

unless @dont_run

  ###
  # Create Admin Users
  ###
  puts "Creating test active admin users"
  superadmin = AdminUser.create!(:email => 'superadmin@digitalaugment.com', :role => "superadmin")
  superadmin.password = 'Password'
  superadmin.password_confirmation = 'Password'
  superadmin.save!
  moderator = AdminUser.create!(:email => 'moderator@digitalaugment.com', :role => "moderator")
  moderator.password = 'Password'
  moderator.password_confirmation = 'Password'
  moderator.save!
  admin = AdminUser.create!(:email => 'admin@digitalaugment.com', :role => "admin")
  admin.password = 'Password'
  admin.password_confirmation = 'Password'
  admin.save!

  ###
  # Create Regular Users
  ###
  USER_NAMES = [%w(Robo Billy), %w(Diabolical Moose), %w(Snappy Turtle), %w(Dirty Badger), %w(Sleepy Pidgeon), %w(Apathetic Tiger), %w(Fuzzy Crab),
                %w(Sad Panda), %w(Kinky Fox)]

  puts "Time: 5 months ago"

  Timecop.freeze(3.months.ago)

  USER_NAMES.each do |user|
    create_user(user[0], user[1])
  end

  Timecop.return
  puts "Time: 3 months ago"

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
                  :user_profile_attributes => {:first_name => "Mike", :last_name => "O'Toole", :display_name => "Subfighter13"},
                  :time_zone => "Pacific Time (US & Canada)",
                  :beta_code => "Chuck Norris")
  mike.skip_confirmation!
  mike.save!

end
