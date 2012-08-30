require 'spec_helper'

describe SubscriptionsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    # it 'does not creates a new subscription if stripe fails to create a token' do
#       exception = Stripe::InvalidRequestError.new("",{})
#       Stripe::Customer.should_receive(:create).and_raise(exception)
#       expect {
#         put :update, subscription: valid_attributes
#       }.to change(Subscription, :count).by(0)
#     end
  end

end
