ActiveAdmin.register Invoice do
  menu parent: "User", priority: 3, if: proc{ can?(:read, User) }
  controller.authorize_resource

  actions :index, :show

  filter :user_email, as: :string, label: "User E-Mail"
  filter :user_user_profile_display_name, as: :string, label: "User Display Name"
  filter :charged_total_price_in_cents
  filter :is_closed, as: :select
  filter :processing_payment
  filter :period_start_date
  filter :period_end_date
  filter :first_failed_attempt_date
  filter :created_at
  filter :updated_at
  filter :deleted_at
  filter :id

  index do
    column "View" do |invoice|
      link_to "View", alexandria_invoice_path(invoice)
    end
    column :user, sortable: false
    column :total_price_in_dollars
    column :period_start_date
    column :period_end_date
    column :paid_date
  end

  show do |invoice|
    attributes_table *default_attribute_table_rows

    div do
      panel("Invoice Items") do
        table_for(invoice.invoice_items) do
          column "View" do |ii|
            link_to "View", alexandria_invoice_item_path(ii)
          end
          column :community
          column :id
          column :title
          column "Price Each" do |ii|
            ii.price_per_month_in_dollars
          end
          column :quantity
          column :total_price_in_dollars
          column :total_price_in_cents
          column :start_date
          column :end_date
          column :is_recurring
          column :is_prorated
        end
      end
    end

    h3 "Active Admin Comments"
    active_admin_comments
  end
end
