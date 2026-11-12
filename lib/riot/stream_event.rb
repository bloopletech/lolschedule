class Riot::StreamEvent
  attr_reader :league_id, :id, :start_time, :streams

  def self.parse(data_response)
    events = data_response.body.dig!("data", "schedule", "events").map { |event| new(event) }
  end

  def initialize(data)
    @league_id = data.dig!("league", "id")
    @id = data.dig!("id")
    @start_time = data.dig!("startTime")
    @streams = data.key?("streams") ? data["streams"].map { |stream| Riot::Stream.new(stream) } : []
  end
end
