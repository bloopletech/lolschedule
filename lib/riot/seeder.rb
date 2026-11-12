class Riot::Seeder
  HOST = "https://esports-api.lolesports.com"
  LEAGUES_ENDPOINT = "#{HOST}/persisted/gw/getLeagues?hl=en-US"
  LIVESTREAMS_ENDPOINT = "#{HOST}/persisted/gw/getLive?hl=en-US"

  def seed
    SyncedStdout.puts "Requesting data..."

    seed_leagues
    seed_tournaments
    seed_events
    seed_schedules
    filter_events
    seed_event_details
    seed_stream_events

    Riot::Data.new(leagues: @leagues, events: @events, event_details: @event_details, stream_events: @stream_events)
  end

  def seed_leagues
    request = Riot::Request.new(url: LEAGUES_ENDPOINT)
    @leagues = Riot::League.parse(request.get)
    filter_leagues
  end

  def filter_leagues
    if ENV.key?("LOLSCHEDULE_LEAGUE_IDS")
      league_ids = ENV["LOLSCHEDULE_LEAGUE_IDS"].split(",")
      @leagues.select! { |league| league_ids.include?(league.id) }
    end
  end

  def seed_tournaments
    requests = @leagues.map(&:tournament_request)
    responses = Parallel.new(requests).perform_collate(&:get)
    @tournaments = responses.flat_map { |response| Riot::Tournament.parse(response) }
    @tournaments.select! { |tournament| tournament.year == Build::CURRENT_YEAR }
  end

  def seed_events
    requests = @tournaments.map(&:events_request)
    responses = Parallel.new(requests).perform_collate(&:get)
    @events = responses.flat_map { |response| Riot::Event.parse(response) }
  end

  def seed_schedules
    @leagues.each { |league| seed_schedules_for(league: league) }
  end

  def seed_schedules_for(league:, page_token: nil)
    request = Riot::Request.new(url: league.schedule_url(page_token), league_id: league.id)
    response = request.get

    @events.concat(Riot::Event.parse(response))

    page_token = response.body.dig("data", "schedule", "pages", "older")
    seed_schedules_for(league: league, page_token: page_token) if page_token
  end

  def filter_events
    @events.uniq! { |event| event.match_id }
    @events.select! { |event| event.year == Build::CURRENT_YEAR }
  end

  def seed_event_details
    requests = @events.select { |event| event.needs_event_detail? }.map(&:event_detail_request)
    responses = Parallel.new(requests).perform_collate(&:get)
    @event_details = responses.flat_map { |response| Riot::EventDetail.parse(response) }
  end

  def seed_stream_events
    request = Riot::Request.new(url: LIVESTREAMS_ENDPOINT)
    @stream_events = Riot::StreamEvent.parse(request.get)
  end
end
