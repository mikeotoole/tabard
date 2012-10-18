# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice_item do
    quantity 1
    association :item, factory: :pro_community_plan
    after(:build)  { |ii| set_invoice(ii) }
  end
end

def set_invoice(ii)
  if ii.community.blank?
    ii.community = DefaultObjects.community_admin_with_stripe.communities.first
  end
  if ii.invoice.blank?
    ii.invoice = FactoryGirl.build(:invoice, user: DefaultObjects.community_admin_with_stripe)
  end
end

# == Schema Information
#
# Table name: invoice_items
#
#  id           :integer          not null, primary key
#  quantity     :integer
#  start_date   :datetime
#  end_date     :datetime
#  item_type    :string(255)
#  item_id      :integer
#  community_id :integer
#  is_recurring :boolean          default(TRUE)
#  is_prorated  :boolean          default(FALSE)
#  invoice_id   :integer
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#