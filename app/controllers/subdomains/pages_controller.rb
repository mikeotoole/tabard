class Subdomains::PagesController < SubdomainsController
  uses_tiny_mce :options => {
                              :theme => 'advanced',
                              :theme_advanced_resizing => true,
                              :theme_advanced_resize_horizontal => false,
                              :plugins => %w{ table fullscreen }
                            },
                :only => [:new, :create, :edit, :update]
  respond_to :html, :xml
  before_filter :authenticate, :except => [:index, :show]
  before_filter :grab_page_space_from_page_space_id

  def index
    @pages = page_helper.all
    respond_with(@pages)
  end

  def show
    @page = page_helper.find(params[:id])
    respond_with(@page)
  end

  def new
    @page = page_helper.new
    if !current_user.can_create(@page)
      render_insufficient_privileges
    else
      respond_with(@page)
    end
  end

  def edit
    @page = page_helper.find(params[:id])
    if !current_user.can_update("Page") and !current_user.can_update(@page)
      render_insufficient_privileges
    end
    repsond_with(@page)
  end

  def create
    @page = page_helper.new(params[:page])
    if !current_user.can_create(@page)
      render_insufficient_privileges
    else
      if @page.save
        add_new_flash_message('Page was successfully created.')
        respond_with([@page_space,@page])
        return
      end 
      grab_all_errors_from_model(@page)
      repsond_with(@page)
    end
  end

  def update
    @page = page_helper.find(params[:id])
    if !current_user.can_update(@page)
      render_insufficient_privileges
    else
      if @page.update_attributes(params[:page])
        add_new_flash_message('Page was successfully updated.')
      end
      grab_all_errors_from_model(@page)
      respond_with([@page_space, @page])
    end
  end

  def destroy
    @page = page_helper.find(params[:id])
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
  
  private
  #Nested Resource Helper
  def game_announcement_helper
    @game ? @game.game_announcements : GameAnnouncement
  end
  
  def grab_game_from_game_id
    @game = Game.find_by_id(params[:game_id]) if params[:game_id]
  end
  
  def page_helper
    @page_space ? @page_space.pages : Page
  end
  
  def grab_page_space_from_page_space_id
    @page_space = PageSpace.find_by_id(params[:page_space_id]) if params[:page_space_id]
  end
end