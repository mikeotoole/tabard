ActiveAdmin.register Community do
  #menu :parent => "Community", :priority => 1
  controller.authorize_resource
  
  filter :name
  filter :slogan
  filter :created_at
  filter :protected_roster, :as => :select
  filter :accepting_members, :as => :select
  filter :email_notice_on_application, :as => :select
  filter :admin_profile
  
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
end
