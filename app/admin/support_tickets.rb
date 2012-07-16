ActiveAdmin.register SupportTicket do
  menu parent: "Crumblin"
  controller.authorize_resource except: :take

  actions :index, :show, :edit, :update

  member_action :take, :method => :put do
    @support_ticket = SupportTicket.find_by_id(params[:id])
    authorize!(:update, @support_ticket)
    @support_ticket.update_attributes(admin_user_id: current_admin_user.id)
    redirect_to :action => :show
  end
  
  action_item :only => :show do
    if can? :update, resource
      link_to "Take", take_admin_support_ticket_path(resource), :method => :put
    end
  end

  filter :status, as: :select, collection: SupportTicket::STATUSES
  filter :admin_user
  filter :user_profile_display_name, :as => :string, :label => "Creator Display Name"
  filter :user_profile_user_email, :as => :string, :label => "Creator E-Mail"
  filter :body
  filter :created_at
  filter :updated_at
  filter :id

  form do |f|
    f.inputs "Support Ticket Details" do
      f.input :admin_user, member_label: :display_name
      f.input :status, as: :select, include_blank: false, collection: SupportTicket::STATUSES
      f.buttons
    end
  end

  index do
    column :body, sortable: :body do |support_ticket|
      link_to support_ticket.body.truncate(50), admin_support_ticket_url(support_ticket)
    end
    column :user_profile do |support_ticket|
      link_to support_ticket.user_profile.full_name, [:admin, support_ticket.user_profile]
    end
    column :admin_user, sortable: :admin_user_id   do |support_ticket|
      link_to support_ticket.admin_user.display_name, [:admin, support_ticket.admin_user] if support_ticket.admin_user
    end
    column "Status" do |support_ticket|
      "#{support_ticket.status}"
    end
    column :created_at
    column "Edit" do |support_ticket|
      link_to "Edit", edit_admin_support_ticket_url(support_ticket)
    end
    column "Take" do |support_ticket|
      link_to "Take", take_admin_support_ticket_path(support_ticket), :method => :put
    end
  end

  show do |ticket|
    attributes_table *default_attribute_table_rows

    h3 "Support Comments"
    div do
      if ticket.support_comments.any?
        ol do
          ticket.support_comments.includes(:admin_user, :user_profile).each do |comment|
            if comment.admin_created?
              li do
                blockquote do
                  div comment.admin_user_display_name
                  div image_tag(comment.admin_user.avatar_url(:small))
                end
                div comment.body
              end
            else
              li do
                blockquote do
                  div comment.user_profile_full_name
                  div image_tag(comment.user_profile.avatar_url(:small))
                end
                div comment.body
              end
            end
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
