ActiveAdmin.register_page "Dashboard" do
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do

        section "Site Actions", priority: 1 do
          if can?(:toggle_maintenance_mode, SiteConfigurationController)
            strong SiteConfiguration.is_maintenance? ? "Maintenance Mode is ON" : "Maintenance Mode is OFF"
            div do
              button_to "Toggle Maintenance Mode", toggle_maintenance_mode_path, method: :post, data: { confirm: 'Are you sure you want to toggle maintenance mode?' }
            end
            div br
          end
          if can?(:sign_out_all_users, User)
            div do
              button_to "Sign Out ALL Users", sign_out_all_users_alexandria_users_path, method: :post, data: { confirm: 'Are you sure you want to sign out ALL users?' }
            end
            div br
          end
          if can?(:update_account, current_admin_user)
            div do
              link_to "Update My Account", edit_account_alexandria_admin_users_path, method: :get
            end
          end
        end

        section "Support Tickets", priority: 1 do
          strong "Unassigned Tickets"
          ul do
            SupportTicket.where{admin_user_id.eq nil}.includes(:user_profile).each do |ticket|
              li link_to "#{ticket.user_profile_full_name} - #{truncate(ticket.body)}", "#"
            end
          end
        end

        section do
          table do
            tr
              th "Stat"
              th "Count"
              th "New This Week"
            tr
              th "Users"
              th "#{User.all.count}"
              th "#{User.where{created_at > 1.week.ago}.count}"
            tr
              th "Communities"
              th "#{Community.all.count}"
              th "#{Community.where{created_at > 1.week.ago}.count}"
            tr
              th "Games"
              th "#{Game.all.count}"
              th "#{Game.where{created_at > 1.week.ago}.count}"
            tr
              th "Characters"
              th "#{Character.all.count}"
              th "#{Character.where{created_at > 1.week.ago}.count}"
          end
        end

      end

      column do
        section "Recent Signed In Admin Users" do
          if can?(:read, AdminUser)
            ul do
              AdminUser.order("current_sign_in_at desc").limit(5).collect do |admin_user|
                li link_to "#{admin_user.email} - #{admin_user.current_sign_in_at ? admin_user.current_sign_in_at.strftime('%m/%d/%Y %I:%M%p') : 'Never Logged In'}", alexandria_admin_user_path(admin_user)
              end
            end
          end
        end

        section "New Games", priority: 3 do
          if can?(:read, Game)
            ul do
              Game.order("created_at desc").limit(5).collect do |game|
                li link_to "#{game.name} - #{game.created_at.strftime('%m/%d/%Y %I:%M%p')}", alexandria_game_path(game)
              end
            end
          end
        end

        section "New Communities", priority: 2 do
          if can?(:read, Community)
            ul do
              Community.order("created_at desc").limit(5).collect do |community|
                li link_to "#{community.name} - #{community.created_at.strftime('%m/%d/%Y %I:%M%p')}", alexandria_community_path(community)
              end
            end
          end
        end

        section "New Users", priority: 2 do
          if can?(:read, User)
            ul do
              User.order("created_at desc").includes(:user_profile).limit(5).collect do |user|
                li link_to "#{user.display_name} - #{user.email} - #{user.created_at.strftime('%m/%d/%Y %I:%M%p')}", alexandria_user_path(user)
              end
            end
          end
        end
      end
    end
  end
end
