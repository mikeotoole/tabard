class PermissionsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /permissions
  # GET /permissions.xml
  def index
    @permissions = Permission.all
    respond_with(@permissions)
  end

  # GET /permissions/1
  # GET /permissions/1.xml
  def show
    @permission = Permission.find(params[:id])
    respond_with(@permission)
  end

  # GET /permissions/new
  # GET /permissions/new.xml
  def new
    @permission = Permission.new
    respond_with(@permission)
  end

  # GET /permissions/1/edit
  def edit
    @permission = Permission.find(params[:id])
    respond_with(@permission)
  end

  # POST /permissions
  # POST /permissions.xml
  def create
    @permission = Permission.new(params[:permission])
    if @permission.save
      flash[:notice] = 'Permission was succesfully created.'
    end
    respond_with(@permission)
  end

  # PUT /permissions/1
  # PUT /permissions/1.xml
  def update
    @permission = Permission.find(params[:id])
    if @permission.update_attributes(params[:permission])
      flash[:notice] = 'Permission was successfully updated.'
    end
    respond_with(@permission)
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.xml
  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy
    respond_with(@permission)
  end
end
