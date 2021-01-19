class Riot::Seeder
  HOST = "https://esports-api.lolesports.com"
  LEAGUES_ENDPOINT = "#{HOST}/persisted/gw/getLeagues?hl=en-US"
  LIVESTREAMS_ENDPOINT = "#{HOST}/persisted/gw/getLive?hl=en-US"

  def seed
    SyncedStdout.puts "Requesting data..."

    data.clear
    leagues
    tournaments
    events
    schedules
    stream_events
  end

  def leagues
    request = Riot::DataRequest.new(url: LEAGUES_ENDPOINT, parent_id: nil)
    data.leagues = Riot::League.parse(request.get)
  end

  def tournaments
    requests = data.leagues.map(&:tournament_request)
    responses = Parallel.new(requests).perform_collate(&:get)
    data.tournaments = responses.flat_map { |response| Riot::Tournament.parse(response) }
  end

  def events
    requests = data.tournaments.map(&:events_request)
    responses = Parallel.new(requests).perform_collate(&:get)
    data.events = responses.flat_map { |response| Riot::Event.parse(response) }
  end

  def schedules
    data.leagues.each do |league|
      schedules_for(league: league, direction: "older", page_token: nil)
      schedules_for(league: league, direction: "newer", page_token: nil)
    end

    data.events.uniq! { |event| event.match_id }
  end

  def schedules_for(league:, direction:, page_token:)
    request = Riot::DataRequest.new(url: league.schedule_url(page_token), parent_id: league.id)
    response = request.get

    data.events.concat(Riot::Event.parse(response))

    followup_page_token = response.body.dig("data", "schedule", "pages", direction)
    schedules_for(league: league, direction: direction, page_token: followup_page_token) if followup_page_token
  end

  def stream_events
    request = Riot::DataRequest.new(url: LIVESTREAMS_ENDPOINT, parent_id: nil)
    data.stream_events = Riot::StreamEvent.parse(request.get)
  end

  def data
    Riot::Data
  end
end
