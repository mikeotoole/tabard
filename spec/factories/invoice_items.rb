# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice_item do
    quantity 1
    association :item, factory: :pro_community_plan
    after(:build) { |ii| set_community(ii) }
    after(:build) { |ii| set_invoice(ii) }
  end

  factory :invoice_item_with_tax, class: InvoiceItem do
    quantity 1
    association :item, factory: :pro_community_plan
    after(:build) { |ii| set_community_with_tax(ii) }
    after(:build) { |ii| set_invoice_with_tax(ii) }
  end

  factory :upgrade_invoice_item, class: InvoiceItem do
    quantity 1
    association :item, factory: :twenty_user_pack_upgrade
    after(:build) { |ii| set_community(ii) }
    after(:build) { |ii| set_invoice(ii) }
    after(:build) { |ii| add_pro_community_plan_ii(ii) }
  end

  factory :basic_invoice_item, class: InvoiceItem do
    quantity 1
    association :item, factory: :pro_community_plan
    after(:build) { |ii| set_community(ii) }
  end
end

def set_community(ii)
  if ii.community.blank?
    ii.community = DefaultObjects.community_admin_with_stripe_out_state.communities.first
  end
end

def set_invoice(ii)
  if ii.invoice.blank? and ii.invoice_id.blank?
    ii.invoice = FactoryGirl.build(:invoice, user_id: DefaultObjects.community_admin_with_stripe_out_state.id)
  end
end

def set_community_with_tax(ii)
  if ii.community.blank?
    ii.community = DefaultObjects.community_admin_with_stripe_in_state.communities.first
  end
end

def set_invoice_with_tax(ii)
  if ii.invoice.blank? and ii.invoice_id.blank?
    ii.invoice = FactoryGirl.build(:invoice, user_id: DefaultObjects.community_admin_with_stripe_in_state.id)
  end
end

def add_pro_community_plan_ii(ii)
  FactoryGirl.build(:invoice_item, invoice: ii.invoice)
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