class Riot::Data
  HOST = "https://esports-api.lolesports.com"
  LEAGUES_ENDPOINT = "#{HOST}/persisted/gw/getLeagues?hl=en-US"
  TOURNAMENTS_ENDPOINT = "#{HOST}/persisted/gw/getTournamentsForLeague?hl=en-US&leagueId="
  VODS_ENDPOINT = "#{HOST}/persisted/gw/getVods?hl=en-US&tournamentId="
  #LIVESTREAM_ENDPOINT = "#{HOST}/api/v2/streamgroups"

  API_KEY = "0TvQnueqKa5mxJntVWt0w4LpLfEkrV1Ta8rQBb9Z"

  def self.seed
    SyncedStdout.puts "Requesting data..."

    @data = {}
    seed_leagues
    seed_tournaments
    seed_events
  end

  def self.seed_leagues
    @data["leagues"] = Riot::League.parse(get(LEAGUES_ENDPOINT))
  end

  def self.seed_tournaments
    urls_keys = @data["leagues"].map { |league| [league.tournament_url, league.id] }.to_h
    responses = Parallel.new(urls_keys.keys).perform_collate { |url| get(url) }
    @data["tournaments"] = responses.map { |url, response| Riot::Tournament.parse(response, urls_keys[url]) }.flatten
  end

  def self.seed_events
    urls_keys = @data["tournaments"].map { |tournament| [tournament.events_url, tournament.league_id] }.to_h
    responses = Parallel.new(urls_keys.keys).perform_collate { |url| get(url) }
    @data["events"] = responses.map { |url, response| Riot::Event.parse(response, urls_keys[url]) }.flatten
  end

  def self.get(url)
    JSON.parse(Client.get(url, API_KEY))
  end

  def self.[](key)
    @data[key]
  end
end