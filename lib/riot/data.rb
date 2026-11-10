class Riot::Data
  attr_reader :leagues, :tournaments, :events, :stream_events, :event_details

  def initialize(leagues:, events:, event_details:, stream_events:)
    @leagues = leagues
    @events = events
    @event_details = event_details
    @stream_events = stream_events
  end
end
