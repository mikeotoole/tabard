###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This is the Home controller.
###
class HomeController < ApplicationController
  ###
  # Before Filters
  ###
  before_filter :authenticate_user!, :except => [:index]

  ###
  # This method gets the index for home.
  ###
  def index
  end

end
