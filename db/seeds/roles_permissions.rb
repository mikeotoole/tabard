###
# Helpers
###

###
# Creates a role with permissions
# [Args]
#   * +community_name+ -> string of community's name.
#   * +community_name+ -> string of new roles name
#   * +community_name+ -> array of strings with the class role should be tied to.
#   * +community_name+ -> array of strings with the name of permissions that should be given to all classes.
#   * +community_name+ -> array of strings with the last name of user role should be given to.
# [Returns] a new role
###
def create_role(community_name, role_name, subject_class_array, permission_level_array, to_users_array)
  puts "#{community_name} is creating a #{role_name} role..."
  role = Community.find_by_name(community_name).roles.create!({name: role_name}, without_protection: true)

  subject_class_array.each do |sub_class|
    permission_level_array.each do |level|
      role.permissions.create!({subject_class: sub_class, permission_level: level}, without_protection: true)
    end
  end

  to_users_array.each do |full_name|
    profile = UserProfile.find_by_full_name(full_name)
    puts "Giving #{profile.name} the #{role_name} role..."
    profile.add_new_role(role)
  end
  return role
end

unless @dont_run

  ###
  # Create Roles with Permissions
  ###

  create_role('Two Maidens', 'n00b', %w(PageSpace), %w(Create), %w(Diabolical\ Moose))

  # Joe's Workaround. Don't kill me Mike
  # TODO upgrade to pro community first
  #puts "Promoting DMoose to officer in JAH..."
  #UserProfile.find_by_last_name("Moose").add_new_role(Community.find_by_name("Just Another Headshot").roles.find_by_name("Officer"))

end