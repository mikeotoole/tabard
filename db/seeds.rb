# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
userResource = SystemResource.create(:name => "User")
roleResource = SystemResource.create(:name => "Role")
gameResource = SystemResource.create(:name => "Game")
wow = Game.create(:name => "World of Warcraft", :type_helper => "Wow", :is_active => true)
swtor = Game.create(:name => "Star Wars the Old Republic", :type_helper => "Swtor", :is_active => true)
blaggarth = Character.create(:name => "Blaggarth", :faction => "Alliance", :race => "Dwarf", :server => "Medivh", :rank => "10", :game => wow, :type_helper => "WowCharacter")
eliand = Character.create(:name => "Eliand", :faction => "Alliance", :race => "Night Elf", :server => "Medivh", :rank => "10", :game => wow, :type_helper => "WowCharacter")
yoda = Character.create(:name => "Yoda", :faction => "Republic", :race => "Species Unknown", :server => "Obi-Wan", :rank => "10", :game => swtor, :type_helper => "SwtorCharacter")
adminProfile = UserProfile.create(:name => "Admin")
userProfile = UserProfile.create(:name => "RoboBilly")
wowProfile = GameProfile.create(:name => "Wow profile", :characters => [blaggarth,eliand], :game => wow, :user_profile => userProfile)
swtorProfile = GameProfile.create(:name => "SWTOR profile", :characters => [yoda], :game => swtor, :user_profile => userProfile)
allUserPermission = Permission.create(:permissionable => userResource, :name => "Full Access User", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allRolePermission = Permission.create(:permissionable => roleResource, :name => "Full Access Role", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allGamePermission = Permission.create(:permissionable => gameResource, :name => "Full Access Game", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
viewUserPermission = Permission.create(:permissionable => userResource, :name => "View Access User", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewRolePermission = Permission.create(:permissionable => roleResource, :name => "View Access Role", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewGamePermission = Permission.create(:permissionable => gameResource, :name => "View Access Game", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
adminRole = Role.create(:name => "Admin", :permissions => [allUserPermission,allRolePermission,allGamePermission])
viewerRole = Role.create(:name => "Viewer", :permissions => [viewUserPermission,viewRolePermission,viewGamePermission])
adminUser = User.create(:email => "admin@example.com", :password => "password", :roles => [adminRole], :user_profile => adminProfile)
viewUser = User.create(:email => "billy@robo.com", :password => "password", :roles => [viewerRole], :user_profile => userProfile)
