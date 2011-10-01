require 'spec_helper'

describe StatusCodeController do

  describe "GET 'forbidden'" do
    it "should be successful" do
      get 'forbidden'
      response.should be_success
    end
  end

end
