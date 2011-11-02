ActiveAdmin.register Discussion do
  menu :parent => "Discussions", :if => proc{ can?(:read, Discussion) }
  controller.authorize_resource
  
  member_action :remove_comment, :method => :delete do
    comment = Comment.find(params[:id])
    if comment.comments.empty?
      comment.destroy
    else
      comment.has_been_deleted = true;
      comment.save
    end
    redirect_to previous_page
  end  
  
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
    column :number_of_comments
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
    attributes_table :id, :name, :body, :discussion_space, :user_profile, :poster, :community, :created_at, :updated_at, :comments_enabled, :has_been_locked, :is_archived
    div do      
      panel("Comments") do
        table_for(discussion.all_comments) do
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
    active_admin_comments
  end   
end
