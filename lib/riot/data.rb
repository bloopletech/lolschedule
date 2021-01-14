class Riot::Data
  class << self
    attr_accessor :leagues, :tournaments, :events

    def clear
      @leagues = []
      @tournaments = []
      @events = []
    end

    def [](key)
      case key
      when "leagues"
        @leagues
      when "tournaments"
        @tournaments
      when "events"
        @events
      end
    end
  end
end
