module FlashResponder
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