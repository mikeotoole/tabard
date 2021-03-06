ActiveAdmin.register Community do
  menu parent: "Community", if: proc{ can?(:read, Community) }
  controller.authorize_resource

  actions :index, :show

  action_item only: [:show] do
    if community.is_charge_exempt
      link_to "Remove charge exempt status", charge_exempt_alexandria_community_url(community), method: :put
    else
      link_to "Grant charge exempt status", charge_exempt_edit_alexandria_community_url(community)
    end
  end

  member_action :destroy, method: :delete do
    community = Community.find(params[:id])
    authorize!(:destroy, community)
    Community.delay.destory_community(community.id)
    flash.now[:notice] = 'Community is being removed.'
    redirect_to action: :index
  end

  member_action :charge_exempt_edit do
    @community = Community.find(params[:id])
    authorize!(:charge_exempt, @community)
  end

  member_action :charge_exempt, method: :put do
    @community = Community.find(params[:id])
    authorize!(:charge_exempt, @community)
    unless params[:community].blank?
      label = params[:community][:charge_exempt_label]
      reason = params[:community][:charge_exempt_reason]
    end
    if @community.toggle_charge_exempt_status(current_admin_user, label, reason)
      flash.now[:notice] = 'Community has had the charge exempt status updated.'
      redirect_to action: :show
    else
      flash.now[:alert] = 'Community has not had the charge exempt status updated.'
      render action: :charge_exempt_edit
    end
  end

  filter :id
  filter :name
  filter :slogan
  filter :created_at
  filter :is_protected_roster, as: :select
  filter :is_accepting_members, as: :select
  filter :email_notice_on_application, as: :select

  index do
    column "View" do |community|
      link_to "View", alexandria_community_path(community)
    end
    column :name
    column :slogan
    column :admin_profile do |community|
      link_to community.admin_profile.name, [:alexandria, community.admin_profile] if community.admin_profile
    end
    column :created_at
    column "Destroy" do |community|
      if can? :destroy, community
        link_to "Destroy", [:alexandria, community], method: :delete, confirm: 'Are you sure you want to delete this community?'
      end
    end
  end

  show title: :name do
    attributes_table *default_attribute_table_rows

    div do
      panel("Members") do
        table_for(community.member_profiles) do
          column "Display Name" do |member_profile|
            link_to member_profile.display_name, [:alexandria, member_profile]
          end
        end
      end
    end

    div do
      panel("Community Games") do
        table_for(community.community_games) do
          column "Name" do |community_game|
            link_to community_game.game_name, [:alexandria, community_game]
          end
          column :full_name
        end
      end
    end

    div id: "discussion_spaces" do
      panel("Discussion Spaces") do
        table_for(community.discussion_spaces) do
          column "Name" do |discussion_space|
            link_to discussion_space.name, [:alexandria, discussion_space]
          end
          column :number_of_discussions, sortable: false
          column :created_at
        end
     end
    end

    div do
      panel("Page Spaces") do
        table_for(community.page_spaces) do
          column "Name" do |page_space|
            link_to page_space.name, [:alexandria, page_space]
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
            link_to custom_form.name, [:alexandria, custom_form]
          end
          column "Number Questions" do |custom_form|
            "#{custom_form.questions.count}"
          end
          column :created_at
        end
      end
    end

    #active_admin_comments
  end
end
