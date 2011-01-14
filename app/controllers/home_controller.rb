class HomeController < ApplicationController
  respond_to :html, :xml
  def index
    respond_with
  end
end
