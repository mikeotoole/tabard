ActiveAdmin.register DiscussionSpace do
  menu :parent => "Discussions", :if => proc{ can?(:read, DiscussionSpace) }
  controller.authorize_resource
  
  actions :index, :show, :update, :edit, :destroy
  
  filter :id
  filter :name
  filter :game
  filter :created_at
  filter :is_announcement, :as => :select
  
  index do
    column "View" do |discussion_space|
      link_to "View", admin_discussion_space_path(discussion_space)
    end
    column :id
    column "Community" do |discussion_space|
      link_to discussion_space.community.name, [:admin, discussion_space.community]
    end
    column :name
    column :game, :sortable => :game_id
    column :created_at
    column :is_announcement
    column :number_of_discussions, :sortable => false
    column "Destroy" do |discussion_space|
      if can? :destroy, discussion_space
        link_to "Destroy", [:admin, discussion_space], :method => :delete, :confirm => 'Are you sure you want to delete this discussion space?'
      end  
    end
  end
  
  show :title => proc{"#{discussion_space.community.name} - #{discussion_space.name}"} do
    attributes_table *default_attribute_table_rows
    div do      
      panel("Discussions") do
        table_for(discussion_space.discussions) do
          column "Name" do |discussion|
            link_to discussion.name, [:admin, discussion]
          end
          column "Poster" do |discussion|
            link_to discussion.poster.name, [:admin, discussion.poster]
          end
          column :number_of_comments, :sortable => false
        end
      end
    end
#     active_admin_comments
  end
  
  form do |f|
    f.inputs "Discussion Space Details" do
      f.input :game
      f.input :name
    end
    f.buttons
  end    
end
