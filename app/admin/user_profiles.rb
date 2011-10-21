ActiveAdmin.register UserProfile do
  menu false
  controller.authorize_resource
  
  show do
    attributes_table :id, :user, :first_name, :last_name, :avatar, :created_at, 
    :updated_at, :description, :display_name, :publicly_viewable, :owned_communities
    h3 "Characters:"
    user_profile.characters.each do |character|
      div do
        link_to character.name, [:admin, character]
      end  
    end
    h3 "Communities:"
    user_profile.communities.each do |community|
      div do
        link_to community.name, [:admin, community]
      end  
    end
    h3 "Owned Communities:"
    user_profile.owned_communities.each do |community|
      div do
        link_to community.name, [:admin, community]
      end  
    end
    active_admin_comments
  end  
end

#  id                :integer         not null, primary key
#  user_id           :integer
#  first_name        :string(255)
#  last_name         :string(255)
#  avatar            :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  description       :text
#  display_name      :string(255)
#  publicly_viewable :boolean  