ActiveAdmin.register Community do
  menu :if => proc{ can?(:read, Community) }
  controller.authorize_resource
  
  actions :index, :show, :destroy
  
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
    div do      
      panel("Discussion Spaces") do
        table_for(community.discussion_spaces) do
          column "Name" do |discussion_space|
            link_to discussion_space.name, [:admin, discussion_space]
          end
          column "Number Discussions" do |discussion_space|
            "#{discussion_space.discussions.count}"
          end
          column :created_at          
        end
      end
    end 
    div do      
      panel("Announcement Spaces") do
        table_for(community.announcement_spaces) do
          column "Name" do |announcement_space|
            link_to announcement_space.name, [:admin, announcement_space]
          end
          column "Number Announcements" do |announcement_space|
            "#{announcement_space.discussions.count}"
          end
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