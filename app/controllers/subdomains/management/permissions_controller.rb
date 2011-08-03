# TODO Add permission protection for this controller - JW
class Subdomains::Management::PermissionsController < SubdomainsController
  respond_to :js, :html
  before_filter :authenticate, :get_role_from_id
  before_filter :get_avalible_permissionables, :only => :new

  def new
    @permission = @role.permissions.new
    respond_with(@permission)
  end

  def edit
    @permission = @role.permissions.find(params[:id])
    respond_with(@permission)
  end

  def delete
    @permission = @role.permissions.find(params[:id])
    respond_with(@permission)
  end

  def create
    @permission = @role.permissions.new(params[:permission])
    if @permission.save
      add_new_flash_message('Permission was succesfully created.')
      respond_with([:management,@role])
    else
      grab_all_errors_from_model(@permission)
      respond_with(@permission)
    end
  end

  def update
    @permission = @role.permissions.find(params[:id])
    if @permission.update_attributes(params[:permission])
      add_new_flash_message('Permission was successfully updated.')
      redirect_to([:management,@role])
    else
      grab_all_errors_from_model(@permission)
      respond_with(@permission)
    end
  end

  def destroy
    @permission = @role.permissions.find(params[:id])
    if @permission.destroy
      flash[:notice] = 'Permission was succesfully deleted.'
      respond_to do |format|
        format.html { redirect_to(:back) }
        format.js { render 'delete' }
      end
    else
      grab_all_errors_from_model(@permission)
      respond_with(@permission)
    end
  end
  
  private
    def get_role_from_id
      @role = Role.find_by_id(params['role_id'])
    end
    
    def get_avalible_permissionables
      @permissionables = Array.new() 
      for resource in SystemResource.all
        case resource.name
        when "DiscussionSpace"
          @discussionHeader = [[resource.id.to_s + "|" + resource.class.to_s, "All "+resource.name.pluralize]]
          @discussionOptions = { "Specific Discussion Space" => @community.discussion_spaces.all.collect{|discussionS| [discussionS.name, discussionS.id.to_s + "|" + discussionS.class.to_s]}}
        when "PageSpace"
          @pageHeader  = [[resource.id.to_s + "|" + resource.class.to_s, "All "+ resource.name.pluralize]]
          pArray = Array.new
          @community.page_spaces.all.each do |pageS| 
            pArray << [pageS.name, pageS.id.to_s + "|" + pageS.class.to_s]
            pageS.pages.each do |page|
              pArray << ["-- #{page.title}", page.id.to_s + "|" + page.class.to_s]
            end
          end
          @pageOptions = { "Specific Page Space" => pArray}
        else
          @permissionables << [resource.id.to_s + "|" + resource.class.to_s, "All "+ resource.name.pluralize]
        end
      end
      #logger.debug(@role.permissions)
      @role.permissions.each { |role_permission|
        @permissionables.delete_if{|permissionable| (permissionable[1].to_s == role_permission.magic_polymorphic_helper)}
      }
    end
end
