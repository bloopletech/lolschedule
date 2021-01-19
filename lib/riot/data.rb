class Riot::Data
  class << self
    attr_accessor :leagues, :tournaments, :events, :stream_events

    def clear
      @leagues = []
      @tournaments = []
      @events = []
      @stream_events = []
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
      end
    end
  end
end
