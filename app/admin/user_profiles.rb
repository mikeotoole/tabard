ActiveAdmin.register UserProfile do
  menu false
  controller.authorize_resource 
  
  show do
    attributes_table :id, :user, :first_name, :last_name, :avatar, :created_at, 
    :updated_at, :description, :display_name, :publicly_viewable, :owned_communities
    div do      
      panel("Characters") do
        table_for(user_profile.characters) do
          column "Name" do |character|
            link_to character.name, [:admin, character]
          end
          column :game
        end
      end
    end 
    div do      
      panel("Comments") do
        table_for(user_profile.comments) do
          column :body
          column :poster
          column :number_of_comments
          column :has_been_deleted
          column "Destroy" do |comment|
            link_to "Destroy", remove_comment_admin_discussion_path(comment), :method => :delete, :confirm => 'Are you sure you want to delete this comment?'
          end
        end
      end
    end
    div do      
      panel("Communities") do
        table_for(user_profile.communities) do
          column "Name" do |community|
            link_to community.name, [:admin, community]
          end
        end
      end
    end
    div do      
      panel("Owned Communities") do
        table_for(user_profile.owned_communities) do
          column "Name" do |community|
            link_to community.name, [:admin, community]
          end
        end
      end
    end
    div do      
      panel("Owned Pages") do
        table_for(user_profile.pages) do
          column "Name" do |page|
            link_to page.name, [:admin, page]
          end
        end
      end
    end
    div do      
      panel("Owned Discussions") do
        table_for(user_profile.discussions) do
          column "Name" do |discussion|
            link_to discussion.name, [:admin, discussion]
          end
        end
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