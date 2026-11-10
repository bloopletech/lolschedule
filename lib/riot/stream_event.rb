class Riot::StreamEvent
  attr_reader :league_id, :id, :start_time, :streams

  def self.parse(data_response)
    events = data_response.body["data"]["schedule"]["events"].map { |event| new(event) }
  end

  def initialize(data)
    @league_id = data["league"]["id"]
    @id = data["id"]
    @start_time = data["startTime"]
    @streams = data.key?("streams") ? data["streams"].map { |stream| Riot::Stream.new(stream) } : []
  end
end
