=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This controller is handling pages within the scope of managment of subdomains (communities).
=end
class Subdomains::Management::PagesController < SubdomainsController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:index, :show]

  def index
    @pages = Page.all
    respond_with(@pages)
  end

  def show
    @page = Page.find(params[:id])
    respond_with(@page)
  end

  def new
    @page = Page.new
    if !current_user.can_create(@page)
      render_insufficient_privileges
    else
      respond_with(@page)
    end
  end

  def edit
    @page = Page.find(params[:id])
    if !current_user.can_update(@page)
      render_insufficient_privileges
    end
    respond_with(@page)
  end

  def create
    @page = Page.new(params[:page])
    if !current_user.can_create(@page)
      render_insufficient_privileges
    else
      if @page.save
        add_new_flash_message('Page was successfully created.')
      end
      grab_all_errors_from_model(@page)
      respond_with(@page)
    end
  end

  def update
    @page = Page.find(params[:id])
    if !current_user.can_update(@page)
      render_insufficient_privileges
    else
      if @page.update_attributes(params[:page])
        add_new_flash_message('Page was successfully updated.')
      end
      grab_all_errors_from_model(@page)
      respond_with(@page)
    end
  end

  def destroy
    @page = Page.find(params[:id])
    if !current_user.can_delete(@page)
      render_insufficient_privileges
    else
      if @page.destroy
        add_new_flash_message('Page was successfully deleted.')
      end
      grab_all_errors_from_model(@page)
      respond_with(@page)
    end
  end
end
