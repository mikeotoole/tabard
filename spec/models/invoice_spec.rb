# == Schema Information
#
# Table name: invoices
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  stripe_invoice_id    :string(255)
#  period_start_date    :datetime
#  period_end_date      :datetime
#  paid_date            :datetime
#  stripe_customer_id   :string(255)
#  discount_percent_off :integer
#  discount_discription :string(255)
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  is_closed            :boolean          default(FALSE)
#

require 'spec_helper'

describe Invoice do
  pending "add some examples to (or delete) #{__FILE__}"
end
