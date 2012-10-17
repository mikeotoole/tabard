ActiveAdmin.register InvoiceItem do
  menu parent: "User", priority: 4, if: proc{ can?(:read, User) }
  controller.authorize_resource

  actions :index, :show

  filter :invoice_user_email, as: :string, label: "User E-Mail"
  filter :invoice_user_user_profile_display_name, as: :string, label: "User Display Name"
  filter :invoice_id, as: :numeric
  filter :start_date
  filter :end_date
  filter :created_at
  filter :updated_at
  filter :deleted_at
  filter :id

  index do
    column "View" do |ii|
      link_to "View", admin_invoice_item_path(ii)
    end
    column :user, sortable: false
    column :invoice_id, sortable: :invoice_id do |ii|
      link_to "#{ii.id}", admin_invoice_path(ii)
    end
    column :total_price_in_dollars, sortable: false
    column :start_date
    column :end_date
  end

  show do |invoice|
    attributes_table *default_attribute_table_rows

    h3 "Active Admin Comments"
    active_admin_comments
  end
end
