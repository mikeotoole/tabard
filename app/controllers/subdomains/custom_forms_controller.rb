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
  prepend_before_filter :block_unauthorized_user!
  before_filter :load_custom_form, :except => [:new, :create, :index]
  before_filter :create_custom_form, :only => [:new, :create]
  authorize_resource :except => [:index, :thankyou, :publish, :unpublish]
  skip_before_filter :limit_subdomain_access

  # GET /custom_forms
  def index
    @custom_forms = current_community.custom_forms
  end

  # GET /custom_forms/new
  def new
  end

  # GET /custom_forms/:id/edit
  def edit
  end

  # POST /custom_forms
  def create
    if @custom_form.save
      add_new_flash_message "Form \"#{@custom_form.name}\" has been created.", 'success'
      respond_with @custom_form, :location => custom_forms_url
    else
      respond_with @custom_form
    end
  end

  # GET /custom_forms/:id/thankyou
  def thankyou
  end

  # PUT /custom_forms/1
  def update
    if @custom_form.update_attributes(params[:custom_form])
      add_new_flash_message "Form \"#{@custom_form.name}\" has been saved.", 'success'
    end
    respond_with @custom_form, :location => custom_forms_url
  end

  # DELETE /custom_forms/1
  def destroy
    if @custom_form
      add_new_flash_message('Form was successfully removed.') if @custom_form.destroy
    end
    respond_with @custom_form
  end

  # PUT /custom_forms/:id/publish
  def publish
    authorize! :update, @custom_form
    @custom_form.is_published = true
    if @custom_form.save
      add_new_flash_message "Form \"#{@custom_form.name}\" has been published.", 'success'
    else
      add_new_flash_message "Unable to publish Form \"#{@custom_form.name}\".", 'alert'
    end
    redirect_to custom_forms_url
  end

  # PUT /custom_forms/:id/unpublish
  def unpublish
    authorize! :update, @custom_form
    @custom_form.is_published = false
    if @custom_form.save
      add_new_flash_message "Form \"#{@custom_form.name}\" has been unpublished.", 'success'
    else
      add_new_flash_message "Unable to publish Form \"#{@custom_form.name}\".", 'alert'
    end
    redirect_to custom_forms_url
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
