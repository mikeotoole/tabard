class HomeController < ApplicationController
  respond_to :html, :xml
  def index
    @communities = Community.all
  end
end
