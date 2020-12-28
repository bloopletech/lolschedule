class Riot::Tournament
  def self.parse(response, league_id)
    response["data"]["leagues"][0]["tournaments"].map { |tournament| new(tournament, league_id) }
  end

  attr_reader :league_id

  def initialize(data, league_id)
    @data = data
    @league_id = league_id
  end

  def id
    @data["id"]
  end

  def slug
    @data["slug"]
  end

  def start_time
    Time.strptime(@data["startDate"], "%Y-%m-%d")
  end

  def end_time
    Time.strptime(@data["endDate"], "%Y-%m-%d")
  end

  def events_url
    "#{Riot::Data::VODS_ENDPOINT}#{id}"
  end
end
