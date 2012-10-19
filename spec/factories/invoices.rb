# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    stripe_charge_id nil
    period_start_date Time.now.beginning_of_day
    period_end_date Time.now.beginning_of_day
    paid_date nil
    discount_percent_off 0
    discount_discription nil
    is_closed nil
    processing_payment nil
    first_failed_attempt_date nil
    after(:build)  { |invoice| add_user(invoice) }
  end
end

def add_user(invoice)
  if invoice.user.blank?
    invoice.user = DefaultObjects.community_admin_with_stripe
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                           :integer          not null, primary key
#  user_id                      :integer
#  stripe_charge_id             :string(255)
#  period_start_date            :datetime
#  period_end_date              :datetime
#  paid_date                    :datetime
#  discount_percent_off         :integer          default(0)
#  discount_discription         :string(255)
#  deleted_at                   :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  is_closed                    :boolean          default(FALSE)
#  processing_payment           :boolean          default(FALSE)
#  charged_total_price_in_cents :integer
#  first_failed_attempt_date    :datetime
#  lock_version                 :integer          default(0), not null
#