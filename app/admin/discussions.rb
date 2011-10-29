ActiveAdmin.register Discussion do
  menu :parent => "Discussions"
  controller.authorize_resource
  
  filter :id
  filter :name
  filter :body
  filter :created_at
  filter :comments_enabled, :as => :select
  filter :has_been_locked, :as => :select
  filter :is_archived, :as => :select
  
  index do
    column :id
    column :name
    column :discussion_space
    column :poster
    column :created_at       
    column "View" do |discussion|
      link_to "View", admin_discussion_path(discussion)
    end
    column "Destroy" do |discussion|
      if can? :destroy, discussion
        link_to "Destroy", [:admin, discussion], :method => :delete, :confirm => 'Are you sure you want to delete this discussion?'
      end  
    end
  end
  
  show do
    attributes_table :name, :body, :discussion_space, :user_profile, :poster, :community, :created_at, :updated_at, :comments_enabled, :has_been_locked, :is_archived
    # TODO Mike, Add Comments
    active_admin_comments
  end   
end
