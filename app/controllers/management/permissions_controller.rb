class Management::PermissionsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate, :get_role_from_id, :get_avalible_permissionables
  # GET /permissions
  # GET /permissions.xml
  def index
    @permissions = @role.permissions.all
    respond_with(@permissions)
  end

  # GET /permissions/1
  # GET /permissions/1.xml
  def show
    @permission = @role.permissions.find(params[:id])
    respond_with(@permission)
  end

  # GET /permissions/new
  # GET /permissions/new.xml
  def new
    @permission = @role.permissions.new
    respond_with(@permission)
  end

  # GET /permissions/1/edit
  def edit
    @permission = @role.permissions.find(params[:id])
    respond_with(@permission)
  end

  # POST /permissions
  # POST /permissions.xml
  def create
    @permission = @role.permissions.new(params[:permission])
    if @permission.save
      add_new_flash_message('Permission was succesfully created.')
      redirect_to([:management,@role])
    else
      respond_with(@permission)
    end
  end

  # PUT /permissions/1
  # PUT /permissions/1.xml
  def update
    @permission = @role.permissions.find(params[:id])
    if @permission.update_attributes(params[:permission])
      add_new_flash_message('Permission was successfully updated.')
      redirect_to([:management,@role])
    else
      respond_with(@permission)
    end
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.xml
  def destroy
    @permission = @role.permissions.find(params[:id])
    if @permission.destroy
      flash[:notice] = 'Permission was succesfully deleted.'
      redirect_to(:back)
    end
  end
  
  private
    def get_role_from_id
      @role = Role.find_by_id(params['role_id'])
    end
    
    def get_avalible_permissionables
      @permissionables = Array.new() 
      for resource in SystemResource.all
        @permissionables << [resource.name, resource.id.to_s + "|" + resource.class.to_s]
      end
      for discussionS in DiscussionSpace.all
        @permissionables << [discussionS.name, discussionS.id.to_s + "|" + discussionS.class.to_s]
      end
      for pageS in PageSpace.all
        @permissionables << [pageS.name, pageS.id.to_s + "|" + pageS.class.to_s]
      end
      logger.debug(@role.permissions)
      @role.permissions.each { |role_permission|
        @permissionables.delete_if{|permissionable| (permissionable[1].to_s == role_permission.magic_polymorphic_helper)}
      }
    end
end
