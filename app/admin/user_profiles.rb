ActiveAdmin.register UserProfile do
  menu parent: "User", priority: 2, if: proc{ can?(:read, UserProfile) }
  controller.authorize_resource

  actions :index, :show

  filter :id
  filter :display_name
  filter :full_name
  filter :avatar
  filter :description
  filter :publicly_viewable, as: :select
  filter :created_at
  filter :updated_at

  index do
    column "View" do |user_profile|
      link_to "View", [:alexandria, user_profile]
    end
    column do |au|
      image_tag(au.avatar_url(:small), class: 'avatar')
    end
    column :display_name
    column "User" do |user_profile|
      link_to user_profile.email, [:alexandria, user_profile.user]
    end
    column :full_name
    column :created_at
  end

  show title: :name do
    attributes_table *default_attribute_table_rows

    div do
      panel("Characters") do
        table_for(user_profile.characters) do
          column "Name" do |character|
            link_to character.name, [:alexandria, character]
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
            link_to comment.poster.name, [:alexandria, comment.poster]
          end
          column :number_of_comments
          column :is_removed
          column "Commentable Body" do |comment|
            link_to comment.commentable_body, [:alexandria, comment.commentable]
          end
          column "Destroy" do |comment|
            link_to "Destroy", remove_comment_alexandria_discussion_path(comment), method: :put, confirm: 'Are you sure you want to delete this comment?'
          end
        end
      end
    end

    div do
      panel("Communities") do
        table_for(user_profile.communities) do
          column "Name" do |community|
            link_to community.name, [:alexandria, community]
          end
        end
      end
    end

    div do
      panel("Owned Communities") do
        table_for(user_profile.owned_communities) do
          column "Name" do |community|
            link_to community.name, [:alexandria, community]
          end
        end
      end
    end

    div do
      panel("Owned Discussions") do
        table_for(user_profile.discussions) do
          column "Name" do |discussion|
            link_to discussion.name, [:alexandria, discussion]
          end
        end
      end
    end

    #active_admin_comments
  end
end
