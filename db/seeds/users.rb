###
# Helpers
###

# Create user
def create_user(full_name, gamer_tag=nil)
  puts "Creating User #{full_name}"
  gamer_tag ||= "#{full_name}"
  gamer_tag = gamer_tag[0..(UserProfile::MAX_GAMER_TAG_LENGTH-1)] if gamer_tag.length > UserProfile::MAX_GAMER_TAG_LENGTH
  email = "#{gamer_tag}@digitalaugment.com"
  user = User.new(accepted_current_terms_of_service: true, accepted_current_privacy_policy: true,
      email: email,
      email_confirmation: email,
      password: "Password",
      time_zone: -8,
      user_profile_attributes: { full_name: full_name, gamer_tag: gamer_tag, display_name: gamer_tag },
      date_of_birth: 22.years.ago.to_date,
      is_email_on_message: false,
      is_email_on_announcement: false,
      beta_code: User::BETA_CODE)
  user.skip_confirmation!
  user.save!
  return user
end

unless @dont_run

  ###
  # Create Admin Users
  ###
  puts "Creating test active admin users"
  superadmin = AdminUser.create!({email: 'superadmin@digitalaugment.com', role: "superadmin", display_name: "Super Admin"}, without_protection: true)
  superadmin.password = 'Password'
  superadmin.password_confirmation = 'Password'
  superadmin.save!
  moderator = AdminUser.create!({email: 'moderator@digitalaugment.com', role: "moderator", display_name: "Moderator"}, without_protection: true)
  moderator.password = 'Password'
  moderator.password_confirmation = 'Password'
  moderator.save!
  admin = AdminUser.create!({email: 'admin@digitalaugment.com', role: "admin", display_name: "Admin"}, without_protection: true)
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
    create_user(user.join(' '), user.join)
  end

  Timecop.return
  puts "Time: 3 months ago"

  puts "Removing Panda accepted documents"
  s_panda = UserProfile.find_by_full_name("Sad Panda")
  s_panda.user.update_column(:accepted_current_terms_of_service, false)
  s_panda.user.update_column(:accepted_current_privacy_policy, false)
  s_panda.user.accepted_documents.destroy_all

  puts "Sleepy Pidgeon is private"
  s_pidgeon = UserProfile.find_by_full_name("Sleepy Pidgeon")
  s_pidgeon.update_column(:publicly_viewable, false)

  puts "Creating a user for Mike, because he thinks our adjective animals aren't cool enough..."
  mike = User.new(accepted_current_terms_of_service: true,
                  accepted_current_privacy_policy: true,
                  email: "mpotoole@gmail.com",
                  email_confirmation: "mpotoole@gmail.com",
                  password: "Password",
                  date_of_birth: Date.new(1980,4,17),
                  user_profile_attributes: {full_name: "Mike O'Toole", gamer_tag: "Subfighter13", display_name: "Subfighter13"},
                  time_zone: -8,
                  beta_code: User::BETA_CODE)
  mike.skip_confirmation!
  mike.save!

end
