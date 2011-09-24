###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This is the controller for top level pages (http://crumblin.com/<page name>)
###
class CrumblinController < ApplicationController
  respond_to :html
###
# Callbacks
###
  before_filter :authenticate_user!, :except => [:index, :intro, :features, :pricing]

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

  # This method gets the Introduction page.
  def intro
  end

  # This method gets the Features page.
  def features
  end

  # This method gets the Pricing page.
  def pricing
  end
end
