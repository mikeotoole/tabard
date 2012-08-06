###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This module checks the permissions for displaying action buttons on show and index pages of active admin panels.
###
module ActiveAdmin
  # Overriding ActiveAdmin Resource methods.
  class Resource
    # New action items module.
    module ActionItems

      alias_method :original_add_default_action_items, :add_default_action_items unless method_defined?(:original_add_default_action_items)

      private

      # New link on index
      def add_default_action_items
        add_action_item except: [:new, :show] do
          if controller.current_ability.can?(:create, active_admin_config.resource_name)
            if controller.action_methods.include?('new')
              link_to(I18n.t('active_admin.new_model', model: active_admin_config.resource_name), new_resource_path)
            end
          end
        end

        # Edit link on show
        add_action_item only: :show do
         if controller.current_ability.can?(:update, resource)
            if controller.action_methods.include?('edit')
              link_to(I18n.t('active_admin.edit_model', model: active_admin_config.resource_name), edit_resource_path(resource))
            end
          end
        end

        # Destroy link on show
        add_action_item only: :show do
          if controller.current_ability.can?(:destroy, resource)
            if controller.action_methods.include?("destroy")
              link_to(I18n.t('active_admin.delete_model', model: active_admin_config.resource_name),
                resource_path(resource),
                method: :delete, :data => { :confirm => I18n.t('active_admin.delete_confirmation') })
            end
          end
        end
      end
    end
  end
end
