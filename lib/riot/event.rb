class Riot::Event
  def self.parse(response, league_id)
    response["data"]["schedule"]["events"].map { |event| new(event.merge("league_id" => league_id)) }
  end

  def initialize(data)
    @data = data
  end

  def league_id
    @data["league_id"]
  end

  def match_id
    @data["match"]["id"]
  end

  def start_time
    @data["startTime"]
  end

  def block_name
    @data["blockName"]
  end

  def teams
    @data["match"]["teams"].map { |team| Riot::Team.new(team.merge("league_id" => league_id)) }
  end

  def games
    @data["games"].map { |game| Riot::Game.new(game) }.select { |game| game.completed? }
  end
end
