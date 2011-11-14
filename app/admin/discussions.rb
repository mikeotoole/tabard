ActiveAdmin.register Discussion do
  menu :parent => "Discussions", :if => proc{ can?(:read, Discussion) }
  controller.authorize_resource

  actions :index, :show, :destroy

  member_action :remove_comment, :method => :put do
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
    column "View" do |discussion|
      link_to "View", admin_discussion_path(discussion)
    end
    column :id
    column :name
    column :discussion_space, :sortable => :discussion_space_id
    column :poster do |discussion|
      link_to discussion.poster.name, [:admin, discussion.poster]
    end
    column :number_of_comments, :sortable => false
    column :created_at
    column "Destroy" do |discussion|
      if can? :destroy, discussion
        link_to "Destroy", [:admin, discussion], :method => :delete, :confirm => 'Are you sure you want to delete this discussion?'
      end
    end
  end

  show :title => proc{ "#{discussion.poster.name} - #{discussion.name}" } do
    rows = default_attribute_table_rows.delete_if { |att| [:character_proxy_id].include?(att) }
    rows.insert(1, :poster)
    attributes_table *rows, :community
    div do
      panel("Comments") do
        table_for(discussion.all_comments) do
          column :body
          column :poster do |comment|
            link_to comment.poster.name, [:admin, comment.poster]
          end
          column :number_of_comments
          column :has_been_deleted
          column "Commentable Body" do |comment|
            comment.commentable_body
          end
          column "Destroy" do |comment|
            link_to "Destroy", remove_comment_admin_discussion_path(comment), :method => :put, :confirm => 'Are you sure you want to delete this comment?'
          end
        end
      end
    end
#     active_admin_comments
  end
end
