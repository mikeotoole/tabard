ActiveAdmin.register Community do
  menu :parent => "Community", :if => proc{ can?(:read, Community) }
  controller.authorize_resource

  actions :index, :show

  member_action :destroy, :method => :delete do
    community = Community.find(params[:id])
    authorize!(:destroy, community)
    Community.delay.destory_community(community.id)
    flash[:notice] = 'Community is being removed.'
    redirect_to :action => :index
  end

  filter :id
  filter :name
  filter :slogan
  filter :created_at
  filter :is_protected_roster, :as => :select
  filter :is_accepting_members, :as => :select
  filter :email_notice_on_application, :as => :select

  index do
    column "View" do |community|
      link_to "View", admin_community_path(community)
    end
    column :name
    column :slogan
    column :admin_profile do |community|
      link_to community.admin_profile.name, [:admin, community.admin_profile] if community.admin_profile
    end
    column :created_at
    column "Destroy" do |community|
      if can? :destroy, community
        link_to "Destroy", [:admin, community], :method => :delete, :confirm => 'Are you sure you want to delete this community?'
      end
    end
  end

  show :title => :name do
    attributes_table *default_attribute_table_rows

    div do
      panel("Members") do
        table_for(community.member_profiles) do
          column "Display Name" do |member_profile|
            link_to member_profile.display_name, [:admin, member_profile]
          end
        end
      end
    end

    div do
      panel("Supported Games") do
        table_for(community.supported_games) do
          column "Name" do |supported_game|
            link_to supported_game.name, [:admin, supported_game]
          end
          column :game_name
        end
      end
    end

    div :id => "discussion_spaces" do
      panel("Discussion Spaces") do
        table_for(community.discussion_spaces) do
          column "Name" do |discussion_space|
            link_to discussion_space.name, [:admin, discussion_space]
          end
          column :number_of_discussions, :sortable => false
          column :created_at
        end
     end
    end

    div do
      panel("Page Spaces") do
        table_for(community.page_spaces) do
          column "Name" do |page_space|
            link_to page_space.name, [:admin, page_space]
          end
          column "Number Pages" do |page_space|
            "#{page_space.pages.count}"
          end
          column :created_at
        end
      end
    end

    div do
      panel("Custom Forms") do
        table_for(community.custom_forms) do
          column "Name" do |custom_form|
            link_to custom_form.name, [:admin, custom_form]
          end
          column "Number Questions" do |custom_form|
            "#{custom_form.questions.count}"
          end
          column :created_at
        end
      end
    end

    active_admin_comments
  end
end
