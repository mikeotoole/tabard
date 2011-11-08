###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling custom forms within communities.
###
class Subdomains::CustomFormsController < SubdomainsController
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :authenticate_user!
  before_filter :load_custom_form, :except => [:new, :create, :index]
  before_filter :create_custom_form, :only => [:new, :create]
  authorize_resource :except => :index
  skip_before_filter :limit_subdomain_access

  # GET /custom_forms
  def index
    @custom_forms = current_community.custom_forms
    authorize! :index, CustomForm
  end

  # GET /custom_forms/1
  def show

  end

  # GET /custom_forms/new
  def new

  end

  # GET /custom_forms/1/edit
  def edit

  end

  # POST /custom_forms
  def create
    add_new_flash_message('Form was successfully created.') if @custom_form.save
    respond_with(@custom_form)
  end

  # PUT /custom_forms/1
  def update
    add_new_flash_message('Form was successfully updated.') if @custom_form.update_attributes(params[:custom_form])
    respond_with(@custom_form)
  end

  # DELETE /custom_forms/1
  def destroy
    if @custom_form
      add_new_flash_message('Form was successfully deleted.') if @custom_form.destroy
    end
    respond_with(@custom_form)
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _before_filter_
  #
  # This before filter attempts to populate @custom_form from the current_community.
  ###
  def load_custom_form
    @custom_form = current_community.custom_forms.find_by_id(params[:id]) if current_community
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to create @custom_form from: custom_forms.new(params[:custom_form]), for the current community.
  ###
  def create_custom_form
    @custom_form = current_community.custom_forms.new(params[:custom_form]) if current_community
  end
end
