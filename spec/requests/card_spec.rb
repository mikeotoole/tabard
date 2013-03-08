require 'spec_helper'

describe "Card" do
  describe "invalid data" do
    describe "with bad address" do
      describe "ad1" do
        it "should not allow save" do
          pending
        end
        it "should inform user of error" do
          pending
        end
      end
      describe "zipcode" do
        it "should not allow save" do
          pending
        end
        it "should inform user of error" do
          pending
        end
      end
    end

    describe "with bad cvc" do
      it "should not allow save" do
        pending
      end
      it "should inform user of error" do
        pending
      end
    end

    describe "with bad expiration" do
      it "should not allow save" do
        pending
      end
      it "should inform user of error" do
        pending
      end
    end

    describe "with bad number" do
      it "should not allow save" do
        pending
      end
      it "should inform user of error" do
        pending
      end
    end
  end

  describe "on first paid plan on edit plan and card" do
    describe "valid card" do
      it "should inform user of success" do
        pending
      end
      it "should change the plan" do
        pending
      end
    end
    describe "valid card with valid attach and charge declined" do
      it "should inform user of error" do
        pending
      end
      it "should not change the plan" do
        pending
      end
    end
    describe "valid card with charge declined" do
      it "should inform user of error" do
        pending
      end
      it "should not change the plan" do
        pending
      end
    end
    describe "valid expired card" do
      it "should inform user of error" do
        pending
      end
      it "should not change the plan" do
        pending
      end
    end
    describe "valid processing error card" do
      it "should inform user of error" do
        pending
      end
      it "should not change the plan" do
        pending
      end
    end
  end

  describe "on edit card and plan" do
    describe "valid card" do
      it "should inform user of success" do
        pending
      end
      it "should change the plan" do
        pending
      end
    end
    describe "valid card with valid attach and charge declined" do
      it "should inform user of success" do
        pending
      end
      it "should change the plan" do
        pending
      end
    end
    describe "valid card with charge declined" do
      it "should inform user of error" do
        pending
      end
      it "should not change the plan" do
        pending
      end
    end
    describe "valid expired card" do
      it "should inform user of error" do
        pending
      end
      it "should not change the plan" do
        pending
      end
    end
    describe "valid processing error card" do
      it "should inform user of error" do
        pending
      end
      it "should not change the plan" do
        pending
      end
    end
  end

  describe "editing card with no pending charge" do
    describe "valid card" do
      it "should inform user of success" do
        pending
      end
    end
    describe "valid card with valid attach and charge declined" do
      it "should inform user of success" do
        pending
      end
    end
    describe "valid card with charge declined" do
      it "should inform user of error" do
        pending
      end
    end
    describe "valid expired card" do
      it "should inform user of error" do
        pending
      end
    end
    describe "valid processing error card" do
      it "should inform user of error" do
        pending
      end
    end
  end

  describe "editing card with pending charge" do
    describe "valid card" do
      it "should inform user of success" do
        pending
      end
    end
    describe "valid card with valid attach and charge declined" do
      it "should inform user of error" do
        pending
      end
    end
    describe "valid card with charge declined" do
      it "should inform user of error" do
        pending
      end
    end
    describe "valid expired card" do
      it "should inform user of error" do
        pending
      end
    end
    describe "valid processing error card" do
      it "should inform user of error" do
        pending
      end
    end
  end
end
