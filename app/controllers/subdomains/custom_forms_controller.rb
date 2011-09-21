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
  before_filter :load_custom_form, :except => [:new, :create]
  before_filter :create_custom_form, :only => [:new, :create]
  authorize_resource
  skip_before_filter :limit_subdomain_access

  # GET /custom_forms
  def index
  end

  # GET /custom_forms/1
  def show
    respond_with(@custom_form)
  end

  # GET /custom_forms/new
  def new
    respond_with(@custom_form)
  end

  # GET /custom_forms/1/edit
  def edit
    respond_with(@custom_form)
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
  # _before_filter_
  #
  # This before filter attempts to populate @custom_forms and @custom_form from the current_community.
  ###
  def load_custom_form
    @custom_forms = current_community.custom_forms
    @custom_form = current_community.custom_forms.find_by_id(params[:id])
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to create @custom_form from: custom_forms.new(params[:custom_form]) or custom_forms.new(), for the current community.
  ###
  def create_custom_form
    if(params[:custom_form])
      @custom_form = current_community.custom_forms.new(params[:custom_form])
    else
      @custom_form = current_community.custom_forms.new
    end
  end
end
