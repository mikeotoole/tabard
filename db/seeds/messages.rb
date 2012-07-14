###
# Helpers
###

# Create a new message with Lorem Ipsum body
def create_message(from_user_last_name, subject, to_last_name_array, body=nil)
  body ||= "Phasellus ornare lacus eu neque hendrerit iaculis in in neque. Phasellus dolor velit, ultrices tempor porttitor eget, lacinia id risus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi nibh nulla, consectetur ut consequat ac, lobortis ut lorem. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum cursus iaculis turpis, vestibulum aliquam tortor pretium non. Phasellus leo mi, suscipit eget facilisis imperdiet, egestas sit amet sapien."

  user_profile = UserProfile.find_by_last_name(from_user_last_name)
  puts "#{user_profile.name} is creating a message"

  to_user_profile_ids = Array.new
  to_last_name_array.each do |last_name|
    to_user_profile_ids << UserProfile.find_by_last_name(last_name).id
  end

  user_profile.sent_messages.create!(
    :to => to_user_profile_ids,
    :subject => subject,
    :body => body)
end

unless @dont_run

  ###
  # Create Messages
  ###
  puts "Time: 3 days ago"
  Timecop.freeze(3.days.ago)

  create_message('Turtle', "April O'Neil is so hawt", %w(Billy))
  create_message('Moose', "I'm a magical ninja", %w(Billy))

  puts "Time: 2 days ago"
  Timecop.return
  Timecop.freeze(2.days.ago)

  create_message('Moose', "I'm a bus!", %w(Billy))

  puts "Time: 1 day ago"
  Timecop.return
  Timecop.freeze(1.days.ago)

  create_message('Fox', "Hey you're cute", %w(Billy))
  create_message('Turtle', "Dudes, let's game it up Friday", %w(Billy Moose Badger))
  create_message('Moose', "I'm a potato gun!", %w(Billy))

  puts "Time: now"
  Timecop.return

  create_message('Billy', "What up Homies?", %w(Moose Badger Fox))
  create_message('Badger', "Mushroom, mushroom!", %w(Billy Fox))

end
