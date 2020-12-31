class Riot::Event
  def self.parse(response, league_id)
    response["data"]["schedule"]["events"].map { |event| new(event, league_id) }
  end

  attr_reader :league_id, :teams, :games

  def initialize(data, league_id)
    @data = data
    @league_id = league_id
    @teams = @data["match"]["teams"].map { |team| Riot::Team.new(team) }
    @games = @data["games"].map { |game| Riot::Game.new(game) }
  end

  def match_id
    @data["match"]["id"]
  end

  def start_time
    @data["startTime"]
  end
end
