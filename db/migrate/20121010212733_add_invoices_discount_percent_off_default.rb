class AddInvoicesDiscountPercentOffDefault < ActiveRecord::Migration
  def up
    change_column_default :invoices, :discount_percent_off, 0
  end

  def down
    change_column_default :invoices, :discount_percent_off, nil
  end
end
