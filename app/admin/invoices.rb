ActiveAdmin.register Invoice do
  menu parent: "User", priority: 3, if: proc{ can?(:read, User) }
  controller.authorize_resource

  actions :index, :show

  filter :status, as: :select, collection: SupportTicket::STATUSES
  filter :admin_user
  filter :user_profile_display_name, :as => :string, :label => "Creator Display Name"
  filter :user_profile_user_email, :as => :string, :label => "Creator E-Mail"
  filter :body
  filter :created_at
  filter :updated_at
  filter :id

  index do
    column "View" do |invoice|
      link_to "View", admin_invoice_path(invoice)
    end
    column :user, sortable: false
    column :user_profile, sortable: false
    column :period_start_date
    column :period_end_date
    column :paid_date
  end

  show do |invoice|
    attributes_table *default_attribute_table_rows

#     if ticket.support_comments.any?
#       div do
#         h3 "Support Comments"
#         ol class: 'comments' do
#           ticket.support_comments.includes(:admin_user, :user_profile).each do |comment|
#             li do
#               blockquote do
#                 cite comment.author_name
#                 span class: 'avatar' do
#                   image_tag(comment.avatar_url(:small), class: 'avatar')
#                 end
#                 span class: 'body' do
#                   simple_format(comment.body)
#                 end
#               end
#             end
#           end
#         end
#       end
#     else
#       p "No comments yet"
#     end

    h3 "Active Admin Comments"
    active_admin_comments
  end
end
