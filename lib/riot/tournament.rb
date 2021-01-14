class Riot::Tournament
  HOST = "https://esports-api.lolesports.com"
  VODS_ENDPOINT = "#{HOST}/persisted/gw/getVods?hl=en-US&tournamentId="

  def self.parse(data_response)
    league_id = data_response.parent_id
    data_response.body["data"]["leagues"][0]["tournaments"].map { |tournament| new(tournament, league_id) }
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
    "#{VODS_ENDPOINT}#{id}"
  end

  def events_request
    Riot::DataRequest.new(url: events_url, parent_id: @league_id)
  end
end
