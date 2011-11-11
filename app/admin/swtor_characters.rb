ActiveAdmin.register SwtorCharacter do
  menu :parent => "Character", :if => proc{ can?(:read, SwtorCharacter) }
  controller.authorize_resource
  
  actions :index, :show, :destroy
  
  filter :id
  filter :name 
  filter :server
  filter :avatar
  filter :created_at
  filter :updated_at
  
  index do
    column "View" do |character|
      link_to "View", admin_swtor_character_path(character)
    end
    column :id
    column :name
    column "User Profile" do |character|
      link_to character.user_profile.display_name, [:admin, character.user_profile]
    end
    column :server
    column :created_at
    column "Destroy" do |character|
      if can? :destroy, character
        link_to "Destroy", [:admin, character], :method => :delete, :confirm => 'Are you sure you want to delete this character?'
      end  
    end
  end
  
  show :title => proc{"#{swtor_character.user_profile.name} - #{swtor_character.name}"} do
    attributes_table *default_attribute_table_rows, :user_profile
#     active_admin_comments
  end  
end