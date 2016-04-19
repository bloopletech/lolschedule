class Models::List < Set
  attr_accessor :source

  def initialize(source, enum = nil)
    @source = source
    super(enum)
  end

  def add(record)
    super(record)
    record.source = @source
    self
  end
  alias << add
end