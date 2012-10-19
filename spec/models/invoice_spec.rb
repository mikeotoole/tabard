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

require 'spec_helper'

describe Invoice do
  let(:invoice_item) { create(:invoice_item) }
  let(:invoice) { invoice_item.invoice.reload }
  let(:community) { DefaultObjects.community_admin_with_stripe.communities.first }
  let(:user_pack) { community.current_community_plan.community_upgrades.first }
  let(:invoice_item_attributes) { { "invoice_items_attributes" => { "0" => { "community_id"=>"#{community.id}",
                                                                             "item_type"=>"#{user_pack.class}",
                                                                             "quantity"=>"1",
                                                                             "item_id"=>"#{user_pack.id}" }}}}

  it "should create a new instance given valid attributes" do
    invoice.should be_valid
  end

###
# Custom Validators
###

  it "should be editable when not closed" do
    invoice.invoice_items.count.should eq 1
    invoice.invoice_items.new({community: community, item: user_pack, quantity: 1}, without_protection: true)
    invoice.save.should be_true
    invoice.invoice_items.count.should eq 2
  end


  it "should not be editable after closed" do
    invoice.mark_paid_and_close.should eq true
    invoice.is_closed.should eq true
    invoice.invoice_items.count.should eq 1
    invoice.invoice_items.new({community: community, item: user_pack, quantity: 1}, without_protection: true)
    invoice.save.should be_false
    invoice.invoice_items.count.should eq 1
  end

###
# Attributes
###
  describe "user" do
    it "should be required" do
      pending
    end
  end

  describe "period_start_date" do
    it "should be required" do
      pending
    end
  end

  describe "period_end_date" do
    it "should be required" do
      pending
    end

    it "should be on or after period start date" do
      pending
    end
  end

  describe "is_closed" do
    it "should not be able to go from true to false or nil" do
      pending
    end
  end

  describe "invoice_items" do
    it "should be valid" do
      pending
    end
    it "should be deleted when invoice is" do
      pending
    end
  end

  describe "scope closed" do
    it "should only return closed invoices" do
      pending
    end

    it "should have the newest invoice first" do
      pending
    end
  end

  describe "scope historical" do
    it "should have the newest invoice first" do
      pending
    end
  end

###
# Callbacks
###
  it "should set charged_total_price_in_cents when closed" do
    pending
  end

  describe "creates next invoice when closed and" do
    it "has only requering invoice items" do
      pending
    end

    it "is not created when no requring invoice items exist" do
      pending
    end
  end

  describe "after save creates prorated invoice items" do
    pending
  end

###
# Methods
###
  describe "total_price_in_cents" do
    it "should return charged_total_price_in_cents when set" do
      pending
    end

    it "should return zero when no invoice items are present" do
      pending
    end

    it "should calculate price using invoice items" do
      pending
    end
  end

  describe "total_price_in_dollars" do
    it "should return total_price_in_cents converted to dollars" do
      pending
    end
  end

  describe "total_recurring_price_per_month_in_cents" do
    describe "when community is given" do
      it "should return the cost for communities invoice items" do
        pending
      end

      it "should only return the cost of given communities items" do
        pending
      end

      it "should only return the cost of requring items" do
        pending
      end
    end

    describe "when community is not given" do
      it "should return the cost for all invoice items" do
        pending
      end

      it "should only return the cost of requring items" do
        pending
      end
    end
  end

  describe "total_recurring_price_per_month_in_dollars" do
    it "should return total_recurring_price_per_month_in_cents converted to dollars when given community" do
      pending
    end

    it "should return total_recurring_price_per_month_in_cents converted to dollars when not given community" do
      pending
    end
  end

  describe "plan_invoice_item_for_community" do
    it "should return recurring community plans invoice item when present" do
      pending
    end

    it "should only return community plans invoice item scoped to community" do
      pending
    end

    it "should return non-recurring community plan invoice item when present" do
      pending
    end

    it "should ignore any prorated community plan invoice items present" do
      pending
    end

    describe "when no community plan invoice items are present" do
      it "should return a new community plan invoice item with default plan" do
        pending
      end

      it "should return a new community plan invoice item with community" do
        pending
      end

      it "should return a new community plan invoice item with quantity of one" do
        pending
      end
    end
  end

  describe "recurring_upgrade_invoice_items_for_community" do
    it "should return recurring community upgrade invoice items when present" do
      pending
    end

    it "should only return recurring community upgrade invoice items" do
      pending
    end

    it "should only return community upgrade invoice items scoped to community" do
      pending
    end

    it "should return an empty array when no recurring community upgrade invoice items are present" do
      pending
    end
  end

  describe "update_attributes_with_payment" do
    describe "when stripe_card_token is nil" do
      it "should return false and add error when admin has no stripe customer id" do
        pending
      end

      it "should save the invoice and invoice items" do
        pending
      end
    end

    describe "when stripe_card_token is given" do
      it "should update or create Stripe customer" do
        pending
      end

      it "should save the invoice and invoice items" do
        pending
      end
    end

    describe "when invoice is not valid" do
      it "should return false" do
        pending
      end

      it "should not save invoice" do
        pending
      end

      it "should not charge customer" do
        pending
      end

      it "should not update or create Stripe customer" do
        pending
      end
    end

    it "should charge customer when invoice is past due" do
      pending
    end

    it "should not charge customer when invoice is not past due" do
      pending
    end
  end

  describe "charge_customer" do
    describe "when customer has not payment info" do
      it "should not close invoice" do
        pending
      end

      it "should return false and set error" do
        pending
      end

      it "should send email when send_fail_email is true" do
        pending
      end
    end

    describe "when total_price_in_cents is less then MINIMUM_CHARGE_AMOUNT" do
      it "should close invoice" do
        pending
      end

      it "should never email customer" do
        pending
      end
    end

    describe "when processing_payment is true" do
      it "should raise ActiveRecord::StaleObjectError" do
        pending
      end

      it "should not close invoice" do
        pending
      end
    end

    describe "when lock_version changes" do
      it "should raise ActiveRecord::StaleObjectError" do
        pending
      end

      it "should not close invoice" do
        pending
      end
    end

    describe "when charge customer is successful" do
      it "should close invoice" do
        pending
      end

      it "should mark paid date" do
        pending
      end

      it "should mark paid date" do
        pending
      end

      it "should set stripe_charge_id" do
        pending
      end

      it "should mark user as_good_standing_account" do
        pending
      end
    end

    describe "when Stripe::CardError is raised" do
      it "should make first_failed_attempt_date when nil" do
        pending
      end

      it "should mark user as_delinquent_account" do
        pending
      end

      describe "when send_fail_email is true and (Time.now - self.first_failed_attempt_date) > SECONDS_OF_FAILED_ATTEMPTS" do
        describe "and no prorated invoice items are present" do
          it "should set all plans to the default plan" do
            pending
          end

          it "should close invoice" do
            pending
          end
        end

        describe "and prorated invoice items are present" do
          it "should remove all recurring invoice items" do
            pending
          end

          it "should not close invoice" do
            pending
          end
        end
      end
    end

    describe "when Stripe::StripeError is raised" do
      it "should not close invoice" do
        pending
      end

      it "should return false and set error" do
        pending
      end
    end
  end

  describe "mark_paid_and_close" do
    it "should set closed to true" do
      pending
    end

    it "should set paid_date to now" do
      pending
    end

    it "should set charge_id" do
      pending
    end

    it "should mark user as in good standing" do
      pending
    end

    it "should email user when charge_id is present" do
      pending
    end

    it "should not email user when charge_id is nil" do
      pending
    end
  end

  describe "uniqued_invoice_items" do
    it "should return invoice items with the same start date, end date, community, is_prorated and is_recurring as new unsaved invoice items" do
      pending
    end
  end
end
