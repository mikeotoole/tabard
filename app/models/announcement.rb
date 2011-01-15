class Announcement < Discussion
  has_many :AcknowledgmentOfAnnouncements
  
  def self.select_options
    descendants.map{ |c| c.to_s }.sort
  end
  
  def type_helper
    self.type
  end
  def type_helper=(type)
    self.type = type
  end
  
end
