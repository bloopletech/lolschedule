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
      result = source.send(relation).find { |record| record.send(foreign_key) == self_value }
      raise "Could not find record in relation #{relation} with #{foreign_key} of #{self_value}" unless result
      result
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

  def inspect
    values = to_h.map { |k, v| "#{k}=#{v.inspect}" }.join(", ")
    "#<#{self.class.name}:#{object_id} #{values}>"
  end
end
