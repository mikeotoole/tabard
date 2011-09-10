###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This is the Home controller.
###
class HomeController < ApplicationController
  respond_to :html
###
# Callbacks
###
  before_filter :authenticate_user!, :except => [:index]

###
# REST Actions
###
  ###
  # This method gets the index for home.
  # If no match constraints(Subdomain)
  # GET /
  ###
  def index
  end
end
