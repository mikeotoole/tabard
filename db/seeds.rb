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
wow = Game.create(:name => "World of Warcraft")
swtor = Game.create(:name => "Star Wars the Old Republic")
blaggarth = Character.create(:name => "Blaggarth", :faction => "Alliance", :race => "Dwarf", :klass => "Warrior", :server => "Medivh", :rank => "10", :game => wow)
eliand = Character.create(:name => "Eliand", :faction => "Alliance", :race => "Night Elf", :klass => "Hunter", :server => "Medivh", :rank => "10", :game => wow)
yoda = Character.create(:name => "Yoda", :faction => "Republic", :race => "Species Unknown", :klass => "Jedi", :server => "Obi-Wan", :rank => "10", :game => swtor)
adminProfile = UserProfile.create(:name => "Admin")
wowProfile = GameProfile.create(:name => "Wow profile", :characters => [blaggarth,eliand], :game => wow)
swtorProfile = GameProfile.create(:name => "SWTOR profile", :characters => [yoda], :game => swtor)
allUserPermission = Permission.create(:permissionable => userResource, :name => "Full Access User", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allRolePermission = Permission.create(:permissionable => roleResource, :name => "Full Access Role", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allGamePermission = Permission.create(:permissionable => gameResource, :name => "Full Access Game", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
adminRole = Role.create(:name => "Admin", :permissions => [allUserPermission,allRolePermission,allGamePermission])
adminUser = User.create(:email => "admin@example.com", :password => "password", :roles => [adminRole], :user_profile => adminProfile, :game_profiles => [wowProfile,swtorProfile])
