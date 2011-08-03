=begin
  Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Don't Steal Me Bro!
  
  This class represents a community observer.
=end
class CommunityObserver < ActiveRecord::Observer
  
=begin
  _after_create_

  This method does nothing at the moment, but would best be used to send an confirmation email to the community owner.
  [Returns] False if the operation could not be preformed, otherwise true.
=end
  def after_create(community)
    #probaly want to send an email
  end
end
