class Riot::StreamEvent
  def self.parse(data_response)
    events = data_response.body["data"]["schedule"]["events"].map { |event| new(event) }
  end

  def initialize(data)
    @data = data
  end

  def league_id
    @data["league"]["id"]
  end

  def id
    @data["id"]
  end

  def start_time
    @data["startTime"]
  end

  def streams
    return [] unless @data.key?("streams")
    @data["streams"].map { |stream| Riot::Stream.new(stream) }.select { |stream| stream.english? }
  end
end
