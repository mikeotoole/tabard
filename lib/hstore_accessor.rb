###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2012 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This module is used to define getters, setters, and finder scopes for keys in a h-store.
###
module HstoreAccessor
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def hstore_accessor(hstore_attribute, *keys)
      Array(keys).flatten.each do |key|
        scope "has_#{key}", lambda { |value| where("#{hstore_attribute} @> (? => ?)", key, value) }

        define_method("#{key}=") do |value|
          send("#{hstore_attribute}=", (send(hstore_attribute) || {}).merge(key.to_s => value))
          send("#{hstore_attribute}_will_change!")
        end
        define_method(key) do
          send(hstore_attribute) && send(hstore_attribute)[key.to_s]
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, HstoreAccessor)