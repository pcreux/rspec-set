class NonActiveRecordClass
  attr_accessor :name

  def initialize(attributes)
    self.name = attributes[:name]
  end

  def self.create(attributes)
    new(attributes)
  end
end