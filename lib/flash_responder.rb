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
      controller.flash[:messages] = Array.new unless controller.flash[:messages]
      if has_errors?
        if options.delete(:behavior) == :list or resource.errors.size == 1
          resource.errors.full_messages.map{ |error|
            controller.flash[:messages] << { :class => 'alert', :title => '', :body => error }
          }
        else
          controller.flash[:messages] << { :class => 'alert', :title => 'Epic Fail', :body => "Multiple errors were found." }
        end
      end
    end
    super
  end
end