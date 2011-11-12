ActiveAdmin.register UserProfile do
  menu :parent => "User", :priority => 2, :if => proc{ can?(:read, UserProfile) }
  controller.authorize_resource 
  
  actions :index, :show
  
#  id                :integer         not null, primary key
#  user_id           :integer
#  first_name        :string(255)
#  last_name         :string(255)
#  avatar            :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  description       :text
#  display_name      :string(255)
#  publicly_viewable :boolean         default(TRUE)
    
  filter :id
  filter :display_name
  filter :first_name
  filter :last_name
  filter :avatar
  filter :description
  filter :publicly_viewable, :as => :select 
  filter :created_at
  filter :updated_at
  
  index do
    column "View" do |user_profile|
      link_to "View", [:admin, user_profile]  
    end
    column :display_name
    column "User" do |user_profile|
      link_to user_profile.user.email, [:admin, user_profile.user]
    end
    column :first_name
    column :last_name
    column :created_at
  end
  
  show :title => :name do
    attributes_table *default_attribute_table_rows
    
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
          column :poster do |comment|
            link_to comment.poster.name, [:admin, comment.poster]
          end
          column :number_of_comments
          column :has_been_deleted          
          column "Commentable Body" do |comment|
            link_to comment.commentable.body, [:admin, comment.original_comment_item]
          end
          column "Destroy" do |comment|
            link_to "Destroy", remove_comment_admin_discussion_path(comment), :method => :put, :confirm => 'Are you sure you want to delete this comment?'
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
    
#     active_admin_comments
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