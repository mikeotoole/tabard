ActiveAdmin.register SupportTicket do
  menu :parent => "Crumblin"
  controller.authorize_resource

  actions :index, :show, :edit, :update

  form do |f|
    f.inputs "Support Ticket Details" do
      f.input :admin_user, :member_label => :display_name
      f.input :status, :as => :select, :include_blank => false, :collection => SupportTicket::STATUSES
      f.buttons
    end
  end

  index do
    column "View" do |support_ticket|
      link_to "View", admin_support_ticket_url(support_ticket)
    end
    column "Update" do |support_ticket|
      link_to "Update", edit_admin_support_ticket_url(support_ticket)
    end
    column :user_profile do |support_ticket|
      link_to support_ticket.user_profile.full_name, [:admin, support_ticket.user_profile]
    end
    column :admin_profile do |support_ticket|
      link_to support_ticket.admin_user.name, [:admin, support_ticket.admin_user] if support_ticket.admin_user
    end
    column :body
    column :created_at
  end

  show do |ticket|
    attributes_table do
      row :user_profile
      row :body
    end
    h3 "Support Comments"
    div do
      ul do
        li "Herp"
        li "Derp"
      end
    end
    h3 "Active Admin Commnets"
    active_admin_comments
  end
end
