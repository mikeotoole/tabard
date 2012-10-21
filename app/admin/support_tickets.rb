ActiveAdmin.register SupportTicket do
  menu parent: "Tabard"
  controller.authorize_resource except: :take

  actions :index, :show, :edit, :update

  member_action :take, :method => :put do
    @support_ticket = SupportTicket.find_by_id(params[:id])
    authorize!(:update, @support_ticket)
    @support_ticket.update_attributes(admin_user_id: current_admin_user.id)
    redirect_to :action => :show
  end

  action_item :only => :show do
    if can?(:update, resource) and resource.admin_user != current_admin_user
      link_to "Take", take_alexandria_support_ticket_path(resource), :method => :put
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
      f.actions
    end
  end

  index do
    column :body, sortable: :body do |support_ticket|
      link_to support_ticket.body.truncate(50), alexandria_support_ticket_url(support_ticket)
    end
    column :user_profile do |support_ticket|
      link_to support_ticket.user_profile.full_name, [:alexandria, support_ticket.user_profile]
    end
    column :admin_user, sortable: :admin_user_id   do |support_ticket|
      link_to support_ticket.admin_user.display_name, [:alexandria, support_ticket.admin_user] if support_ticket.admin_user
    end
    column "Status" do |support_ticket|
      "#{support_ticket.status}"
    end
    column :created_at
    column "Edit" do |support_ticket|
      link_to "Edit", edit_alexandria_support_ticket_url(support_ticket)
    end
    column "Take" do |support_ticket|
      link_to "Take", take_alexandria_support_ticket_path(support_ticket), :method => :put unless support_ticket.admin_user == current_admin_user
    end
  end

  show do |ticket|
    attributes_table *default_attribute_table_rows

    if ticket.support_comments.any?
      div do
        h3 "Support Comments"
        ol class: 'comments' do
          ticket.support_comments.includes(:admin_user, :user_profile).each do |comment|
            li do
              blockquote do
                cite comment.author_name
                span class: 'avatar' do
                  image_tag(comment.avatar_url(:small), class: 'avatar')
                end
                span class: 'body' do
                  simple_format(comment.body)
                end
              end
            end
          end
        end
      end
    else
      p "No comments yet"
    end

    panel('New Comment') do
      active_admin_form_for [:alexandria, ticket, SupportComment.new] do |f|
        f.inputs do
          f.input :body, label: false
        end
        f.buttons
      end
    end

    h3 "Active Admin Comments"
    active_admin_comments
  end
end
