class AddFirstFailedAttemptDateToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :first_failed_attempt_date, :datetime
  end
end
