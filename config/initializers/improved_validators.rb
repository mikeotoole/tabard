module ActiveRecord::Validations::ClassMethods
  def validates_associated(association, options = {})
    class_eval do
      validates_each(association) do |record, associate_name, value|
        associate = record.send(associate_name)
        if associate && !associate.valid?
          associate.errors.each do |key, value|
            record.errors.add("#{associate_name}_#{key}", value)
          end
        end
      end
    end
  end
end