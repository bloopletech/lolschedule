class Riot::Tournament
  HOST = "https://esports-api.lolesports.com"
  VODS_ENDPOINT = "#{HOST}/persisted/gw/getVods?hl=en-US&tournamentId="

  def self.parse(response)
    tournaments = response.body.dig!("data", "leagues", 0, "tournaments")
    tournaments.map { |tournament| new(tournament.merge("league_id" => response.league_id)) }
  end

  attr_reader :league_id, :id, :slug

  def initialize(data)
    @league_id = data.dig!("league_id")
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
    Riot::Request.new(url: events_url, league_id:)
  end
end
