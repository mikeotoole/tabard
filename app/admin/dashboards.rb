ActiveAdmin::Dashboards.build do

  section "Site Actions", :priority => 1 do
    if can?(:toggle_maintenance_mode, SiteActionController)
      strong SiteActionController.new.maintenance_mode? ? "Maintenance Mode is ON" : "Maintenance Mode is OFF"
      div do
        button_to "Toggle Maintenance Mode", toggle_maintenance_mode_path, :method => :put, :confirm => 'Are you sure you want to toggle maintenance mode?'
      end
      div br
    end
    if can?(:sign_out_all_users, User)
      div do
        button_to "Sign Out ALL Users", sign_out_all_users_admin_users_path, :method => :post, :confirm => 'Are you sure you want to sign out ALL users?'
      end
      div br
    end
    if can?(:update_account, current_admin_user)
      div do
        button_to "Update My Account", edit_account_admin_admin_users_path, :method => :get
      end
    end
  end

  section "Recent Signed In Admin Users" do
    if can?(:read, AdminUser)
      ul do
        AdminUser.order("current_sign_in_at desc").limit(5).collect do |admin_user|
          li link_to "#{admin_user.email} - #{admin_user.current_sign_in_at ? admin_user.current_sign_in_at.strftime('%m/%d/%Y %I:%M%p') : 'Never Logged In'}", admin_admin_user_path(admin_user)
        end
      end
    end
  end

  section "New SWTOR Characters", :priority => 3 do
    if can?(:read, SwtorCharacter)
      ul do
        SwtorCharacter.order("created_at desc").limit(5).collect do |character|
          li link_to "#{character.display_name} - #{character.created_at.strftime('%m/%d/%Y %I:%M%p')}", admin_swtor_character_path(character)
        end
      end
    end
  end
  section "New WoW Characters", :priority => 3 do
    if can?(:read, WowCharacter)
      ul do
        WowCharacter.order("created_at desc").limit(5).collect do |character|
          li link_to "#{character.display_name} - #{character.created_at.strftime('%m/%d/%Y %I:%M%p')}", admin_wow_character_path(character)
        end
      end
    end
  end

  section "Recent Signed In Users", :priority => 2 do
    if can?(:read, User)
      ul do
        User.order("current_sign_in_at desc").limit(5).collect do |user|
          if user.current_sign_in_at
            li link_to "#{user.display_name} - #{user.email} - #{user.current_sign_in_at.strftime('%m/%d/%Y %I:%M%p')}", admin_user_path(user)
          end
        end
      end
    end
  end

  section "New Communities", :priority => 2 do
    if can?(:read, Community)
      ul do
        Community.order("created_at desc").limit(5).collect do |community|
          li link_to "#{community.name} - #{community.created_at.strftime('%m/%d/%Y %I:%M%p')}", admin_community_path(community)
        end
      end
    end
  end

  section "New Users", :priority => 2 do
    if can?(:read, User)
      ul do
        User.order("created_at desc").limit(5).collect do |user|
          li link_to "#{user.display_name} - #{user.email} - #{user.created_at.strftime('%m/%d/%Y %I:%M%p')}", admin_user_path(user)
        end
      end
    end
  end

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.

  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end

  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end

  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
