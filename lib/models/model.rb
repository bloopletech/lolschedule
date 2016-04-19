class Models::Model
  attr_accessor :source

  class << self
    attr_reader :fields

    def set_fields(*fields)
      @fields = fields
      
      attr_accessor *@fields
    end
  end

  def self.finder(name:, relation:, key:, foreign_key:)
    define_method(name) do
      return nil unless source

      self_value = send(key)
      source.send(relation).find { |record| record.send(foreign_key) == self_value }
    end
  end

  def initialize(attributes = {})
    attributes.each_pair do |attr, value|
      send("#{attr}=", value)
    end
  end
  
  def to_h
    Hash[self.class.fields.map { |field| [field.to_s, send(field)] }]
  end

=begin
  def source=(source)
    @source = source
    record_list = source.list_for(self)
    (record_list << self) unless record_list.include?(self)
    @source
  end
=end
end
