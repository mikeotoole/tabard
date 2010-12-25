class Character < ActiveRecord::Base
 belongs_to :game
 
 validates_presence_of :name
 
 def self.factory(type, params = nil)
    params[:type] ||= 'Character'
    class_name = params[:type]
    if defined? class_name.constantize
    class_name.constantize.new(params)
    else
    Character.new(params)
    end
 end
 
end
