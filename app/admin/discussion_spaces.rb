ActiveAdmin.register DiscussionSpace do
  menu :parent => "Discussions", :if => proc{ can?(:read, DiscussionSpace) }
  controller.authorize_resource

  actions :index, :show, :update, :edit
  
  member_action :destroy, :method => :delete do
    space = DiscussionSpace.find(params[:id])
    authorize!(:destroy, space)
    space.delay_destory
    add_new_flash_message('Discussion Space is being removed.')
    redirect_to :action => :index
  end

  filter :id
  filter :name
  filter :created_at
  filter :is_announcement_space, :as => :select

  index do
    column "View" do |discussion_space|
      link_to "View", admin_discussion_space_path(discussion_space)
    end
    column :id
    column "Community" do |discussion_space|
      link_to discussion_space.community_name, [:admin, discussion_space.community]
    end
    column :name
    column :supported_game, :sortable => :supported_game_id
    column :created_at
    column :is_announcement_space
    column :number_of_discussions, :sortable => false
  end

  show :title => :name do
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
          column :number_of_comments
        end
      end
    end
#     active_admin_comments
  end

  form do |f|
    f.inputs "Discussion Space Details" do
      f.input :supported_game, :collection => f.object.community.supported_games
      f.input :name
    end
    f.buttons
  end
end
