ActiveAdmin.register CommunityApplication do
  menu parent: "Community", if: proc{ can?(:read, CommunityApplication) }
  controller.authorize_resource

  actions :index, :show

  filter :id
  filter :name
  filter :game
  filter :created_at

  index do
    column "View" do |community_application|
      link_to "View", [:alexandria,community_application]
    end
    column :id
    column "Community" do |community_application|
      link_to community_application.community_name, [:alexandria, community_application.community]
    end
  end

  show title: :community_name do
    attributes_table *default_attribute_table_rows
    div do
      panel("Comments") do
        table_for(community_application.comments) do
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
