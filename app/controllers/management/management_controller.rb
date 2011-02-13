class Management::ManagementController < ApplicationController
  before_filter :authenticate
  
  def index
    @registration_application_space = DiscussionSpace.registration_application_space
  end
  
end
