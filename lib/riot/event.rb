class Riot::Event
  HOST = "https://esports-api.lolesports.com"
  EVENT_DETAIL_ENDPOINT = "#{HOST}/persisted/gw/getEventDetails?hl=en-US&id="

  attr_reader :league_id, :match_id, :start_time, :block_name, :teams, :games

  def self.parse(response)
    events = response.body.dig!("data", "schedule", "events")
    events.reject! { |event| event["type"] == "show" }
    events.map { |event| new(event.merge("league_id" => response.league_id)) }
  end

  def initialize(data)
    @league_id = data.dig!("league_id")
    @match_id = data.dig!("match", "id")
    @start_time = data.dig!("startTime")
    @block_name = data.dig!("blockName")
    @teams = data.dig!("match", "teams").map { |team| Riot::Team.new(team.merge("league_id" => @league_id)) }
    @games = (data["games"] || []).map { |game| Riot::Game.new(game) }.select { |game| game.completed? }
  end

  def year
    start_time[0..3].to_i
  end

  def needs_event_detail?
    @games.any? { |game| game.needs_event_detail? }
  end

  def event_detail_url
    "#{EVENT_DETAIL_ENDPOINT}#{match_id}"
  end

  def event_detail_request
    Riot::Request.new(url: event_detail_url, league_id:)
  end
end
