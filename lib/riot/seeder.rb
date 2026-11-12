class Riot::Seeder
  def initialize
    @client = Riot::Client.new
  end

  def get(request)
    @client.get(request)
  end

  def parallel_get(requests)
    @client.parallel_get(requests)
  end

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
    response = get(Riot::League.request)
    @leagues = Riot::League.parse(response)
    filter_leagues
  end

  def filter_leagues
    if ENV.key?("LOLSCHEDULE_LEAGUE_IDS")
      league_ids = ENV["LOLSCHEDULE_LEAGUE_IDS"].split(",")
      @leagues.select! { |league| league_ids.include?(league.id) }
    end
  end

  def seed_tournaments
    responses = parallel_get(@leagues.map(&:tournament_request))
    @tournaments = responses.flat_map { |response| Riot::Tournament.parse(response) }
    @tournaments.select! { |tournament| tournament.year == Build::CURRENT_YEAR }
  end

  def seed_events
    responses = parallel_get(@tournaments.map(&:events_request))
    @events = responses.flat_map { |response| Riot::Event.parse(response) }
  end

  def seed_schedules
    @leagues.each { |league| seed_schedules_for(league: league) }
  end

  def seed_schedules_for(league:, page_token: nil)
    response = get(Riot::Request.new(league.schedule_url(page_token), league.id))

    @events.concat(Riot::Event.parse(response))

    page_token = response.body.dig("data", "schedule", "pages", "older")
    seed_schedules_for(league: league, page_token: page_token) if page_token
  end

  def filter_events
    @events.uniq! { |event| event.match_id }
    @events.select! { |event| event.year == Build::CURRENT_YEAR }
  end

  def seed_event_details
    responses = parallel_get(@events.select { |event| event.needs_event_detail? }.map(&:event_detail_request))
    @event_details = responses.flat_map { |response| Riot::EventDetail.parse(response) }
  end

  def seed_stream_events
    response = get(Riot::StreamEvent.request)
    @stream_events = Riot::StreamEvent.parse(response)
  end
end
