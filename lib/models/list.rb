class Models::List
  attr_accessor :source
  extend Forwardable
  def_delegators :to_a, :each, :map, :select

  def initialize(source)
    @source = source
    @index = {}
  end

  def <<(record)
    record.source = @source
    @index[record.riot_id] = record
    self
  end

  def to_a
    @index.values
  end
  alias :all :to_a

  def find(riot_id)
    @index[riot_id]
  end

  def find_all(riot_ids)
    @index.values_at(*riot_ids).compact
  end

  def delete(riot_id)
    @index.delete(riot_id)
  end
end