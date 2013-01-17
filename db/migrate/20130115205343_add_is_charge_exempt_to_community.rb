class AddIsChargeExemptToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :is_charge_exempt, :boolean, default: false
    add_column :communities, :charge_exempt_authorizer_id, :integer
    add_column :communities, :charge_exempt_start_time, :datetime
    add_column :communities, :charge_exempt_label, :string
    add_column :communities, :charge_exempt_reason, :text
  end
end
