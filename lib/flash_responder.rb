###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This responder groups together and adds functionality to the default flash alert/error/notice/messaging.
###
module FlashResponder

  # Strips the data from flash[:alert], flash[:error], and flash[:notice] and places it within the flash[:messages] array
  def to_html
    unless get? || options.delete(:flash) == false
      namespace = controller.controller_path.split('/')
      namespace << controller.action_name
      if has_errors?
        if options.delete(:error_behavior) == :list or resource.errors.size == 1
          resource.errors.full_messages.map{ |error|
            controller.flash.now[:alert] = error
          }
        else
          controller.flash.now[:alert] = "Multiple errors were found."
        end
      end
    end
    super
  end
end
