###
# Helpers
###

# Create a invite
def create_community_invite(sponsor_full_name, community_name, applicant_full_name)
  community = Community.find_by_name(community_name)
  sponsor = UserProfile.find_by_full_name(sponsor_full_name)
  applicant = UserProfile.find_by_full_name(applicant_full_name)
  puts "#{sponsor.display_name} is inviting #{applicant.display_name} to #{community.name}"
  applicant.community_invite_applications.create!({community: community, sponsor: sponsor}, without_protection: true)
end
unless @dont_run

  ###
  # Create community invites
  ###
  create_community_invite("Robo Billy", "Just Another Headshot", "Apathetic Tiger")

end