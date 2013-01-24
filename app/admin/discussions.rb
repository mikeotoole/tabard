ActiveAdmin.register Discussion do
  menu parent: "Discussions", if: proc{ can?(:read, Discussion) }
  controller.authorize_resource

  actions :index, :show, :destroy

  member_action :remove_comment, method: :put do
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to request.referer ? request.referer : alexandria_dashboard_url
  end

  filter :id
  filter :name
  filter :body
  filter :created_at
  filter :is_locked, as: :select

  index do
    column "View" do |discussion|
      link_to "View", alexandria_discussion_path(discussion)
    end
    column :id
    column :name
    column :discussion_space, sortable: :discussion_space_id
    column :poster do |discussion|
      link_to discussion.poster.name, [:alexandria, discussion.poster]
    end
    column :number_of_comments
    column :created_at
    column "Destroy" do |discussion|
      if can? :destroy, discussion
        link_to "Destroy", [:alexandria, discussion], method: :delete, confirm: 'Are you sure you want to delete this discussion?'
      end
    end
  end

  show title: :name do
    rows = default_attribute_table_rows.delete_if { |att| [:character_id].include?(att) }
    rows.insert(1, :poster)
    attributes_table *rows, :community
    div do
      panel("Comments") do
        table_for(discussion.all_comments) do
          column :body
          column :poster do |comment|
            link_to comment.poster.name, [:alexandria, comment.poster]
          end
          column :number_of_comments
          column :is_removed
          column "Commentable Body" do |comment|
            comment.commentable_body
          end
          column "Destroy" do |comment|
            link_to "Destroy", remove_comment_alexandria_discussion_path(comment), method: :put, confirm: 'Are you sure you want to delete this comment?'
          end
        end
      end
    end
    #active_admin_comments
  end
end
