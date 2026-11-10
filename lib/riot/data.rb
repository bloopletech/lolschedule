class Riot::Data
  class << self
    attr_accessor :leagues, :tournaments, :events, :stream_events, :event_details

    def clear
      @leagues = []
      @tournaments = []
      @events = []
      @stream_events = []
      @event_details
    end

    def [](key)
      case key
      when "leagues"
        @leagues
      when "tournaments"
        @tournaments
      when "events"
        @events
      when "stream_events"
        @stream_events
      when "event_details"
        @event_details
      end
    end
  end
end
