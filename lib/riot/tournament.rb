class Riot::Tournament
  HOST = "https://esports-api.lolesports.com"
  VODS_ENDPOINT = "#{HOST}/persisted/gw/getVods?hl=en-US&tournamentId="

  def self.parse(data_response)
    league_id = data_response.parent_id
    data_response.body.dig!("data", "leagues", 0, "tournaments").map { |tournament| new(tournament, league_id) }
  end

  attr_reader :league_id, :id, :slug

  def initialize(data, league_id)
    @league_id = league_id
    @id = data.dig!("id")
    @slug = data.dig!("slug")
    @start_time = data.dig!("startDate")
    @end_time = data.dig!("endDate")
  end

  def start_time
    Time.strptime(@start_time, "%Y-%m-%d")
  end

  def end_time
    Time.strptime(@end_time, "%Y-%m-%d")
  end

  def year
    start_time.year
  end

  def events_url
    "#{VODS_ENDPOINT}#{id}"
  end

  def events_request
    Riot::DataRequest.new(url: events_url, parent_id: @league_id)
  end
end
