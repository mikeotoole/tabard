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
#  charged_state_tax_rate       :float            default(0.0)
#  charged_local_tax_rate       :float            default(0.0)
#  local_tax_code               :string(255)
#  disputed_date                :datetime
#  refunded_date                :datetime
#  refunded_price_in_cents      :integer
#  tax_error_occurred           :boolean          default(FALSE)
#

require 'spec_helper'

describe Invoice do
  let(:invoice) { DefaultObjects.invoice }
  let(:invoice_with_tax) { DefaultObjects.invoice_with_tax }
  let(:community) { DefaultObjects.community_admin_with_stripe_out_state.communities.first }
  let(:pro_plan) {
    plan = CommunityPlan.find_by_title("Pro Community")
    if plan.blank?
      plan = create(:pro_community_plan)
    end
    plan
  }
  let(:user_pack) { pro_plan.community_upgrades.first }
  let(:invoice_item_attributes) { { "invoice_items_attributes" => { "0" => { "community_id"=>"#{community.id}",
                                                                             "item_type"=>"#{user_pack.class}",
                                                                             "quantity"=>"1",
                                                                             "item_id"=>"#{user_pack.id}" }}}}

  # New user
  let(:new_admin) { DefaultObjects.community_admin }
  let(:new_invoice) {DefaultObjects.community_admin.current_invoice }
  let(:invoice_item_attributes_new_plan) { { "invoice_items_attributes" => { "0" => { "community_id"=>"#{DefaultObjects.community.id}",
                                                                                      "item_type"=>"#{pro_plan.class}",
                                                                                      "quantity"=>"1",
                                                                                      "item_id"=>"#{pro_plan.id}" }}}}


  it "should create a new instance given valid attributes" do
    invoice.should be_valid
  end

###
# Custom Validators
###

  it "should be editable when not closed" do
    invoice.is_closed.should be_false
    invoice.invoice_items.new({community: community, item: user_pack, quantity: 1})
    expect {
      invoice.save.should be_true
    }.to change(InvoiceItem, :count).by(1)
  end


  it "should not be editable after closed" do
    invoice.mark_paid_and_close.should be_true
    invoice.is_closed.should be_true
    invoice.invoice_items.new({community: community, item: user_pack, quantity: 1})
    expect {
      invoice.save.should be_false
    }.to change(InvoiceItem, :count).by(0)
  end

###
# Attributes
###
  describe "user" do
    it "should be required" do
      build(:invoice, user_id: nil).should_not be_valid
    end
  end

  describe "period_start_date" do
    it "should be required" do
      build(:invoice, period_start_date: nil).should_not be_valid
    end
  end

  describe "period_end_date" do
    it "should be required" do
      build(:invoice, period_end_date: nil).should_not be_valid
    end

    it "should be on or after period start date" do
      build(:invoice, period_start_date: Time.now, period_end_date: 1.day.ago).should_not be_valid
    end
  end

  describe "is_closed" do
    it "should not be able to go from true to false or nil" do
      invoice.mark_paid_and_close.should eq true
      invoice.is_closed.should eq true
      invoice.is_closed = false
      invoice.save.should eq false
      invoice.reload
      invoice.is_closed.should eq true
      invoice.is_closed = nil
      invoice.save.should eq false
      invoice.reload
      invoice.is_closed.should eq true
    end
  end

  describe "invoice_items" do
    it "should be valid" do
      ii = invoice.invoice_items.new({community: community, quantity: 1})
      ii.should_not be_valid
      invoice.should_not be_valid
    end

    it "should be deleted when invoice is" do
      iis = invoice.invoice_items.all.to_a
      iis.should_not be_empty
      invoice.destroy
      Invoice.exists?(invoice).should eq false
      iis.each do |ii|
        InvoiceItem.exists?(ii).should eq false
      end
    end
  end

  describe "scope closed" do
    it "should only return closed invoices" do
      invoice
      Invoice.all.count.should eq 2
      Invoice.closed.count.should eq 1
    end

    it "should have the newest invoice first" do
      closed_invoice2 = create(:invoice, period_start_date: 2.days.ago.beginning_of_day, period_end_date: 2.days.ago.beginning_of_day)
      closed_invoice1 = create(:invoice)
      closed_invoice1.mark_paid_and_close
      closed_invoice2.mark_paid_and_close
      Invoice.closed.first.should eq closed_invoice1
      Invoice.closed.last.should eq closed_invoice2
    end
  end

  describe "scope historical" do
    it "should have the newest invoice first" do
      invoice2 = create(:invoice, period_start_date: 2.days.ago.beginning_of_day, period_end_date: 2.days.ago.beginning_of_day)
      invoice
      Invoice.historical.first.should eq invoice
      Invoice.historical.last.should eq invoice2
    end
  end

###
# Callbacks
###
  it "should set charged_total_price_in_cents when closed" do
    invoice.charged_total_price_in_cents.should be_nil
    invoice.mark_paid_and_close
    invoice.charged_total_price_in_cents.should eq invoice.invoice_items.map{|ii| ii.price_per_month_in_cents}.inject('+')
  end

  describe "creates next invoice when closed and" do
    it "has requering and prorated invoice items" do
      invoice.invoice_items.recurring.any?.should be_true
      invoice.invoice_items.prorated.any?.should be_true

      Timecop.travel invoice.period_end_date

      expect {
        invoice.mark_paid_and_close.should be_true
      }.to change(Invoice, :count).by(1)

      new_invoice = Invoice.last
      new_invoice.invoice_items.should_not be_empty
      new_invoice.invoice_items.each do |ii|
        ii.is_recurring.should eq true
      end
    end
  end

  it "does not create next invoice when closed when no requring invoice items exist" do
    invoice.invoice_items.count.should eq 3
    invoice.invoice_items.select(&:is_recurring).each do |ii|
      ii.destroy
    end
    invoice.reload
    invoice.invoice_items.recurring.any?.should eq false
    invoice.invoice_items.count.should eq 1
    Invoice.all.count.should eq 2
    Timecop.travel invoice.period_end_date
    invoice.mark_paid_and_close
    Invoice.all.count.should eq 2
  end

  it "should create prorated invoice items after save" do
    start_count = invoice.invoice_items.prorated.count
    Timecop.travel Time.now + 15.days
    ii = invoice.invoice_items.select{|ii| ii.item == user_pack and ii.is_recurring == true}.first
    ii.quantity = 2
    invoice.save.should be_true
    invoice.reload
    invoice.invoice_items.prorated.count.should eq start_count + 1
    invoice.invoice_items.prorated.last.number_of_days.should eq 15
  end

###
# Methods
###
  describe "total_price_in_cents" do
    it "should return charged_total_price_in_cents when set" do
      invoice.update_column(:charged_total_price_in_cents, 555)
      invoice.total_price_in_cents.should eq 555
    end

    it "should include tax and untaxed total when tax is present" do
      invoice_with_tax.total_tax_in_cents.should_not eq 0
      total = invoice_with_tax.total_tax_in_cents + invoice_with_tax.total_price_in_cents_without_tax
      total.should eq invoice_with_tax.total_price_in_cents
    end

    it "should include equal untaxed total when tax is not present" do
      invoice.total_tax_in_cents.should eq 0
      invoice.total_price_in_cents.should eq invoice.total_price_in_cents_without_tax
    end

    it "should return zero when no invoice items are present" do
      invoice = create(:invoice)
      invoice.invoice_items.should be_empty
      invoice.total_price_in_cents.should eq 0
    end

    it "should calculate price using invoice items" do
      invoice.total_price_in_cents.should eq invoice.invoice_items.map(&:price_per_month_in_cents).inject('+')
    end
  end

  describe "total_price_in_dollars" do
    it "should return total_price_in_cents converted to dollars" do
      invoice.total_price_in_dollars.should eq invoice.total_price_in_cents / 100.0
    end
  end

  describe "total_price_in_cents_without_tax" do
    describe "when tax is present" do
      it "should equal the cost of all invoice items" do
        invoice_with_tax.invoice_items.count.should_not eq 0
        price = 0.0
        invoice_with_tax.invoice_items.each do |ii|
          price = price + ii.total_price_in_cents
        end
        invoice_with_tax.total_price_in_cents_without_tax.should eq price
      end
    end
    describe "when tax is not present" do
      it "should equal the cost of all invoice items" do
        invoice.invoice_items.count.should_not eq 0
        price = 0.0
        invoice.invoice_items.each do |ii|
          price = price + ii.total_price_in_cents
        end
        invoice.total_price_in_cents_without_tax.should eq price
      end
    end
  end

  describe "total_price_in_dollars_without_tax" do
    it "should eq total_price_in_cents_without_tax converted to dollars" do
      invoice_with_tax.total_price_in_dollars_without_tax.should eq (invoice_with_tax.total_price_in_cents_without_tax / 100.0)
    end
  end

  describe "total_tax_in_cents" do
    describe "when tax is present" do
      it "should eq tax rate times total_price_in_cents_without_tax" do
        invoice_with_tax.tax_rate.should_not eq 0.0
        invoice_with_tax.total_tax_in_cents.should eq (invoice_with_tax.tax_rate * invoice_with_tax.total_price_in_cents_without_tax).round(0)
      end
    end
    describe "when tax is not present" do
      it "should be zero" do
        invoice.tax_rate.should eq 0.0
        invoice.total_tax_in_cents.should eq 0
      end
    end
  end

  describe "total_tax_in_dollars" do
    it "should eq total_tax_in_cents converted to dollars" do
      invoice_with_tax.total_tax_in_dollars.should eq (invoice_with_tax.total_tax_in_cents / 100.0)
    end
  end

  describe "should_be_taxed?" do
    it "should return false when tax is zero" do
      invoice.total_tax_in_cents.should eq 0
      invoice.should_be_taxed?.should be_false
    end

    it "should return true when tax is not zero" do
      invoice_with_tax.total_tax_in_cents.should_not eq 0
      invoice_with_tax.should_be_taxed?.should be_true
    end
  end

  describe "tax_rate" do
    it "should return zero when user is not in WA" do
      invoice.tax_rate.should eq 0
    end
    it "should not return zero when user is in WA" do
      invoice_with_tax.tax_rate.should_not eq 0
    end
  end

  describe "total_recurring_price_per_month_in_cents" do
    describe "when community is given" do
      it "should return the cost for communities invoice items" do
        community2 = create(:community, admin_profile_id: invoice.user.user_profile.id)
        invoice.invoice_items.create({community: community2, item: pro_plan, quantity: 1}).should be_true

        invoice.invoice_items.select{|ii| ii.community_id == community2.id and ii.is_recurring == true}.count.should eq 1
        invoice.total_recurring_price_per_month_in_cents(community2).should eq pro_plan.price_per_month_in_cents
      end

      it "should only return the cost of recurring items" do
        community2 = create(:community, admin_profile_id: invoice.user.user_profile.id)
        invoice.invoice_items.new({community: community2, item: pro_plan, quantity: 1})
        invoice.save.should be_true
        Timecop.travel Time.now + 15.days
        invoice.invoice_items.new({community: community2, item: user_pack, quantity: 1})
        invoice.save.should be_true
        invoice.reload
        invoice.invoice_items.select{|ii| ii.community_id == community2.id and ii.is_recurring == true}.count.should eq 2
        invoice.total_recurring_price_per_month_in_cents(community2).should eq pro_plan.price_per_month_in_cents + user_pack.price_per_month_in_cents
      end
    end

    describe "when community is not given" do
      it "should return the cost for all invoice items" do
        recurring_ii = invoice.invoice_items.select{|ii| ii.is_recurring == true}
        non_recurring_ii = invoice.invoice_items.select{|ii| ii.is_recurring == false}
        recurring_ii.any?.should be_true
        non_recurring_ii.any?.should be_true
        invoice.total_recurring_price_per_month_in_cents.should eq recurring_ii.map{|ii| ii.price_per_month_in_cents}.inject('+')
      end
    end
  end

  describe "total_recurring_price_per_month_in_dollars" do
    it "should return total_recurring_price_per_month_in_cents converted to dollars when given community" do
      invoice.total_recurring_price_per_month_in_dollars.should_not eq 0
      invoice.total_recurring_price_per_month_in_dollars.should eq invoice.total_recurring_price_per_month_in_cents/100.0
    end

    it "should return total_recurring_price_per_month_in_cents converted to dollars when not given community" do
      invoice.total_recurring_price_per_month_in_dollars(community).should_not eq 0
      invoice.total_recurring_price_per_month_in_dollars(community).should eq invoice.total_recurring_price_per_month_in_cents/100.0
    end
  end

  describe "plan_invoice_item_for_community" do
    it "should return recurring community plans invoice item when present" do
      ii = invoice.plan_invoice_item_for_community(community)
      ii.community.should eq community
      ii.item.should eq pro_plan
    end

    it "should ignore any prorated community plan invoice items present" do
      community2 = create(:community, admin_profile_id: invoice.user.user_profile.id)
      Timecop.travel Time.now + 15.days
      ii = invoice.invoice_items.new({community: community2, item: pro_plan, quantity: 1})
      invoice.save.should be_true
      invoice.reload
      prorated_plan = invoice.invoice_items.select{|ii| ii.community_id == community2.id and ii.item == pro_plan and ii.is_prorated == true}
      prorated_plan.blank?.should be_false
      invoice.plan_invoice_item_for_community(community2).should eq ii
    end

    describe "when no community plan invoice items are present" do
      it "should return a new community plan invoice item with default plan" do
        community2 = create(:community, admin_profile_id: invoice.user.user_profile.id)
        ii = invoice.plan_invoice_item_for_community(community2)
        ii.item.title.should eq "Free Community"
        ii.price_per_month_in_cents.should eq 0
      end

      it "should return a new community plan invoice item with community" do
        community2 = create(:community, admin_profile_id: invoice.user.user_profile.id)
        ii = invoice.plan_invoice_item_for_community(community2)
        ii.community.should eq community2
      end

      it "should return a new community plan invoice item with quantity of one" do
        community2 = create(:community, admin_profile_id: invoice.user.user_profile.id)
        ii = invoice.plan_invoice_item_for_community(community2)
        ii.quantity.should eq 1
      end
    end
  end

  describe "recurring_upgrade_invoice_items_for_community" do
    it "should return recurring community upgrade invoice items when present" do
      ii = invoice.invoice_items.select{|ii| ii.community_id == community.id and ii.item == user_pack and ii.is_recurring == true}
      invoice.recurring_upgrade_invoice_items_for_community(community).should eq ii
    end

    it "should only return recurring community upgrade invoice items" do
      ii = invoice.invoice_items.select{|ii| ii.community_id == community.id and ii.item == user_pack and ii.is_recurring == true}
      invoice.invoice_items.select{|ii| ii.community_id == community.id and ii.item == user_pack and ii.is_recurring == false}.any?.should eq true
      invoice.recurring_upgrade_invoice_items_for_community(community).should eq ii
    end

    it "should only return community upgrade invoice items scoped to community" do
      community2 = create(:community, admin_profile_id: invoice.user.user_profile.id)
      invoice.invoice_items.new({community: community2, item: pro_plan, quantity: 1})
      invoice.invoice_items.new({community: community2, item: user_pack, quantity: 1})
      invoice.save.should be_true
      invoice.reload
      ii = invoice.invoice_items.select{|ii| ii.community_id == community.id and ii.item == user_pack and ii.is_recurring == true}
      invoice.recurring_upgrade_invoice_items_for_community(community).should eq ii
    end

    it "should return an empty array when no recurring community upgrade invoice items are present" do
      community2 = create(:community, admin_profile_id: invoice.user.user_profile.id)
      invoice.invoice_items.new({community: community2, item: pro_plan, quantity: 1})
      invoice.save.should be_true
      invoice.reload
      invoice.invoice_items.select{|ii| ii.community_id == community2.id and ii.item == user_pack and ii.is_recurring == true}.any?.should eq false
      invoice.recurring_upgrade_invoice_items_for_community(community2).should eq []
    end
  end

  describe "update_attributes_with_payment" do
    describe "when stripe_card_token is nil" do
      it "should return false and add error when admin has no stripe customer id" do
        invoice.user.update_column(:stripe_customer_token, nil)
        invoice.user_stripe_customer_token.should be_nil
        ret = invoice.update_attributes_with_payment(invoice_item_attributes)
        ret.should be_false
        invoice.errors.empty?.should be_false
      end

      it "should save the invoice and invoice items" do
        invoice
        lambda {
          ret = invoice.update_attributes_with_payment(invoice_item_attributes)
          ret.should be_true
        }.should change(InvoiceItem, :count).by(2) # Creates new prorated item and recurring item.
      end
    end

    describe "when stripe_card_token is given" do
      before(:each) do
         new_admin.stripe_customer_token.should be_nil
         new_invoice.persisted?.should be_false
      end


      it "should update or create Stripe customer" do
        new_invoice.update_attributes_with_payment(invoice_item_attributes_new_plan, DefaultObjects.stripe_card_token_out_state)
        new_admin.reload
        new_admin.stripe_customer_token.should_not be_nil
      end

      it "should save the invoice and invoice items" do
        lambda {
          ret = new_invoice.update_attributes_with_payment(invoice_item_attributes_new_plan, DefaultObjects.stripe_card_token_out_state)
          ret.should be_true
        }.should change(InvoiceItem, :count).by(2) # Create this ii then close invoice and create ii for next invoice.

        new_invoice.is_closed.should be_true
      end
    end

    describe "when invoice is not valid" do
      it "should return false" do
        ret = invoice.update_attributes_with_payment(invoice_item_attributes_new_plan)
        ret.should be_false
      end

      it "should not save invoice" do
        invoice
        lambda {
          ret = invoice.update_attributes_with_payment(invoice_item_attributes_new_plan)
          ret.should be_false
        }.should change(InvoiceItem, :count).by(0)
      end

      it "should not charge customer" do
        ret = invoice.update_attributes_with_payment(invoice_item_attributes_new_plan)
        ret.should be_false
        invoice.charged_total_price_in_cents.should be_nil
      end

      it "should not update or create Stripe customer" do
        invoice
        new_admin.stripe_customer_token.should be_nil
        new_invoice.update_attributes_with_payment(invoice_item_attributes, DefaultObjects.stripe_card_token_out_state)
        new_admin.reload
        new_admin.stripe_customer_token.should be_nil
      end
    end

    it "should charge customer when invoice is past due" do
      invoice
      Timecop.travel Time.now + 31.days
      ret = invoice.update_attributes_with_payment(invoice_item_attributes)
      ret.should be_true
      invoice.charged_total_price_in_cents.should eq invoice.total_price_in_cents
    end

    it "should not charge customer when invoice is not past due" do
      ret = invoice.update_attributes_with_payment(invoice_item_attributes)
      ret.should be_true
      invoice.charged_total_price_in_cents.should be_nil
    end
  end

  describe "charge_customer" do

    describe "when customer has no payment info" do
      before(:each) { invoice.user.update_column(:stripe_customer_token, nil) }

      it "should not close invoice" do
        invoice.charge_customer
        invoice.is_closed.should be_false
      end

      it "should return false and set error" do
        ret = invoice.charge_customer
        ret.should be_false
        invoice.errors.empty?.should be_false
      end
    end

    describe "when total_price_in_cents is less then MINIMUM_CHARGE_AMOUNT" do
      it "should close invoice" do
        invoice.stub(:total_price_in_cents) { 20 }
        invoice.charge_customer
        invoice.is_closed.should be_true
        invoice.charged_total_price_in_cents.should eq 20
        invoice.stripe_charge_id.should be_nil
      end
    end

    describe "when processing_payment is true" do
      before(:each) { invoice.stub(:processing_payment) { true } }

      it "should raise error ActiveRecord::StaleObjectError" do
        expect { invoice.charge_customer }.to raise_error(ActiveRecord::StaleObjectError)
      end

      it "should not close invoice" do
        expect { invoice.charge_customer }.to raise_error(ActiveRecord::StaleObjectError)
        invoice.is_closed.should be_false
      end
    end

    describe "when lock_version changes" do
      before(:each) { invoice.stub(:lock_version) { 2000 } }

      it "should raise error ActiveRecord::StaleObjectError" do
        expect { invoice.charge_customer }.to raise_error(ActiveRecord::StaleObjectError)
      end

      it "should not close invoice" do
        expect { invoice.charge_customer }.to raise_error(ActiveRecord::StaleObjectError)
        invoice.is_closed.should be_false
      end
    end

    describe "when charge customer is successful" do
      it "should close invoice" do
        invoice.charge_customer
        invoice.is_closed.should be_true
      end

      it "should mark paid date" do
        Timecop.freeze
        invoice.charge_customer
        invoice.paid_date.should eq Time.now
      end

      it "should set stripe_charge_id" do
        invoice.charge_customer
        invoice.stripe_charge_id.should_not be_nil
      end

      it "should mark user as_good_standing_account" do
        invoice.user.update_column(:is_in_good_account_standing, false)
        invoice.charge_customer
        invoice.user.is_in_good_account_standing.should be_true
      end
    end

    describe "when Stripe::CardError is raised" do
      before(:each) { Stripe::Charge.stub(:create).and_raise(Stripe::CardError.new("Test", nil, "card_declined")) }

      it "should make first_failed_attempt_date when nil" do
        Timecop.freeze
        invoice.first_failed_attempt_date.should be_nil
        invoice.charge_customer
        invoice.first_failed_attempt_date.should eq Time.now
      end

      it "should mark user as_delinquent_account" do
        invoice.charge_customer
        invoice.reload
        invoice.user.is_in_good_account_standing.should be_false
      end

      it "should not close invoice" do
        invoice.charge_customer
        invoice.is_closed.should be_false
      end

      it "should return false and set error" do
        ret = invoice.charge_customer
        ret.should be_false
        invoice.errors.empty?.should be_false
      end

      describe "when send_fail_email is true and (Time.now - self.first_failed_attempt_date) > SECONDS_OF_FAILED_ATTEMPTS" do
        it "should call cancel_subscription" do
          invoice.stub(:first_failed_attempt_date) { (Invoice::SECONDS_OF_FAILED_ATTEMPTS + 60).seconds.ago }
          invoice.should_receive(:cancel_subscription)
          invoice.charge_customer
        end
      end
    end
  end

  describe "cancel_subscription" do
    describe "and no prorated invoice items are present" do
      before(:each) {
        invoice.stub(:first_failed_attempt_date) { (Invoice::SECONDS_OF_FAILED_ATTEMPTS + 60).seconds.ago }
        invoice.invoice_items.select(&:is_prorated).each do |ii|
          ii.delete
        end
        invoice.reload
      }

      it "should set all plans to the default plan and remove all upgrades" do
        invoice.cancel_subscription
        invoice.invoice_items.each do |ii|
          ii.item.should eq CommunityPlan.default_plan
        end
      end

      it "should have total_price_in_cents equal to zero" do
        invoice.cancel_subscription
        invoice.total_price_in_cents.should eq 0
      end

      it "should close invoice" do
        invoice.cancel_subscription
        invoice.is_closed.should be_true
      end
    end

    describe "and prorated invoice items are present" do
      it "should remove all recurring invoice items" do
        invoice.invoice_items.select{|ii| ii.is_recurring == true}.count.should_not eq 0
        invoice.invoice_items.select{|ii| ii.is_prorated == true}.count.should_not eq 0

        invoice.cancel_subscription

        invoice.invoice_items.each do |ii|
          ii.is_prorated.should be_true
          ii.is_recurring.should be_false
        end
      end

      it "should not close invoice" do
        invoice.cancel_subscription
        invoice.is_closed.should be_false
      end

      it "should make invoice return DefaultPlan for user's community" do
        user = invoice.user
        user.communities.count.should eq 1
        community = user.communities.first

        plan_ii = invoice.plan_invoice_item_for_community(community)

        Timecop.travel(plan_ii.start_date + 1.day)

        community.current_community_plan.is_free_plan?.should be_false

        invoice.cancel_subscription

        community.current_community_plan.is_free_plan?.should be_true
      end
    end
  end

  describe "mark_paid_and_close" do
    it "should set closed to true" do
      closed_invoice1 = create(:invoice)
      closed_invoice1.mark_paid_and_close
      closed_invoice1.is_closed.should eq true
    end

    it "should set paid_date to now" do
      closed_invoice1 = create(:invoice)
      Timecop.freeze
      closed_invoice1.mark_paid_and_close
      closed_invoice1.paid_date.should eq Time.now
    end

    it "should set charge_id" do
      closed_invoice1 = create(:invoice)
      closed_invoice1.mark_paid_and_close("test-charge-id")
      closed_invoice1.stripe_charge_id.should eq "test-charge-id"
    end

    it "should mark user as in good standing" do
      user = invoice.user
      user.is_in_good_account_standing = false
      user.save.should eq true
      user.is_in_good_account_standing.should eq false
      invoice.mark_paid_and_close
      user.is_in_good_account_standing.should eq true
    end
  end

  describe "uniqued_invoice_items" do
    it "should return invoice items with the same start date, end date, community, is_prorated and is_recurring as new unsaved invoice items" do
      invoice.invoice_items.count.should eq 3
      invoice.invoice_items.new({community: community, item: user_pack, quantity: 1})
      invoice.invoice_items.new({community: community, item: user_pack, quantity: 1})
      invoice.save.should be_true
      invoice.invoice_items.count.should eq 5

      invoice.uniqued_invoice_items.count.should eq 3
    end
  end
end
