class Models::List
  attr_accessor :source
  extend Forwardable
  def_delegators :@data, :each, :map, :select, :first

  def initialize(source)
    @source = source
    @data = []
    @index = {}
  end

  def <<(record)
    record.source = @source
    @data << record
    @index[record.riot_id] = record
    self
  end

  def find(riot_id)
    @index[riot_id]
  end

  def find_all(riot_ids)
    @index.values_at(*riot_ids).compact
  end
end