ActiveAdmin.register DiscussionSpace do
  menu :parent => "Discussions"
  controller.authorize_resource
  
  filter :id
  filter :name
  filter :game
  filter :created_at
  filter :is_announcement, :as => :select
  
  index do
    column :id
    column :community
    column :name
    column :game
    column :created_at
    column :is_announcement
    column "View" do |discussion_space|
      link_to "View", admin_discussion_space_path(discussion_space)
    end
    column "Destroy" do |discussion_space|
      if can? :destroy, discussion_space
        link_to "Destroy", [:admin, discussion_space], :method => :delete, :confirm => 'Are you sure you want to delete this discussion space?'
      end  
    end
  end
  
  show do
    attributes_table :id, :community, :name, :game, :created_at, :updated_at, :is_announcement
    h3 "Discussions:"
    discussion_space.discussions.each do |discussion|
      div do
        link_to discussion.name, [:admin, discussion]
      end  
    end
    active_admin_comments
  end  
end
