class Riot::Event
  def self.parse(data_response)
    league_id = data_response.parent_id
    events = data_response.body["data"]["schedule"]["events"]
    events.reject! { |event| event["type"] == "show" }
    events.map { |event| new(event.merge("league_id" => league_id)) }
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

  def year
    start_time[0..3].to_i
  end

  def block_name
    @data["blockName"]
  end

  def teams
    @data["match"]["teams"].map { |team| Riot::Team.new(team.merge("league_id" => league_id)) }
  end

  def games
    return [] unless @data.key?("games")
    @data["games"].map { |game| Riot::Game.new(game) }.select { |game| game.completed? }
  end
end
