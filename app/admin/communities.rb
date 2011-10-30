ActiveAdmin.register Community do
  controller.authorize_resource
  
  filter :name
  filter :slogan
  filter :created_at
  filter :protected_roster, :as => :select
  filter :accepting_members, :as => :select
  filter :email_notice_on_application, :as => :select
  
  index do
    column :name
    column :slogan
    column :admin_profile
    column :created_at
    column "View" do |community|
      link_to "View", admin_community_path(community)
    end
    column "Destroy" do |community|
      if can? :destroy, community
        link_to "Destroy", [:admin, community], :method => :delete, :confirm => 'Are you sure you want to delete this community?'
      end  
    end
  end
  
  show do
    attributes_table :id, :name, :slogan, :accepting_members, :email_notice_on_application, :subdomain, :created_at, 
    :updated_at, :admin_profile, :member_role_id, :protected_roster, :community_application_form_id, :community_announcement_space_id
    h3 "Discussion Spaces:"
    community.discussion_spaces.each do |discussion_space|
      div do
        link_to discussion_space.name, [:admin, discussion_space]
      end
    end
    h3 "Announcement Spaces:"
    community.announcement_spaces.each do |announcement_space|
      div do
        link_to announcement_space.name, [:admin, announcement_space]
      end  
    end
    h3 "Page Spaces:"
    community.page_spaces.each do |page_space|
      div do
        link_to page_space.name, [:admin, page_space]
      end  
    end
    h3 "Custom Forms:"
    community.custom_forms.each do |custom_form|
      div do
        link_to custom_form.name, [:admin, custom_form]
      end  
    end
    active_admin_comments
  end  
end