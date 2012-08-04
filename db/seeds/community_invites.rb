###
# Helpers
###

# Create a invite
def create_community_invite(sponsor_last_name, community_name, applicant_last_name)
  community = Community.find_by_name(community_name)
  sponsor = UserProfile.find_by_last_name(sponsor_last_name)
  applicant = UserProfile.find_by_last_name(applicant_last_name)
  puts "#{sponsor.display_name} is inviting #{applicant.display_name} to #{community.name}"
  applicant.community_invite_applications.create!({community: community, sponsor: sponsor}, without_protection: true)
end
unless @dont_run

  ###
  # Create community invites
  ###
  create_community_invite("Billy", "Just Another Headshot", "Tiger")

end