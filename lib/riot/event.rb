class Riot::Event
  def self.parse(response, league_id)
    response["data"]["schedule"]["events"].map { |event| new(event, league_id) }
  end

  attr_reader :league_id, :teams

  def initialize(data, league_id)
    @data = data
    @league_id = league_id
    @teams = @data["match"]["teams"].map { |team| Riot::Team.new(team) }
  end

  def match_id
    @data["match"]["id"]
  end

  def start_time
    @data["startTime"]
  end

  def games_parameters
    parameters = []
    @data["games"].each do |game|
      game["vods"].each do |vod|
        parameters << vod["parameter"]
      end
    end

    parameters
  end
end
