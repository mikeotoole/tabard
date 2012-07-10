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
    column :admin_user do |support_ticket|
      link_to support_ticket.admin_user.display_name, [:admin, support_ticket.admin_user] if support_ticket.admin_user
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
      if ticket.support_comments.any?
        ol do
          ticket.support_comments.each do |comment|
            li comment.to_yaml
          end
        end
      else
        p "No comments yet"
      end
      div do
        link_to "New Comment", new_admin_support_ticket_support_comment_url(ticket)
      end
    end
    h3 "Active Admin Comments"
    active_admin_comments
  end
end
