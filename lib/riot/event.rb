class Riot::Event
  HOST = "https://esports-api.lolesports.com"
  EVENT_DETAIL_ENDPOINT = "#{HOST}/persisted/gw/getEventDetails?hl=en-US&id="

  attr_reader :league_id, :match_id, :start_time, :block_name, :teams

  def self.parse(data_response)
    league_id = data_response.parent_id
    events = data_response.body["data"]["schedule"]["events"]
    events.reject! { |event| event["type"] == "show" }
    events.map { |event| new(event.merge("league_id" => league_id)) }
  end

  def initialize(data)
    @league_id = data["league_id"]
    @match_id = data["match"]["id"]
    @start_time = data["startTime"]
    @block_name = data["blockName"]
    @teams = data["match"]["teams"].map { |team| Riot::Team.new(team.merge("league_id" => @league_id)) }
  end

  def year
    start_time[0..3].to_i
  end

  def event_detail_url
    "#{EVENT_DETAIL_ENDPOINT}#{match_id}"
  end

  def event_detail_request
    Riot::DataRequest.new(url: event_detail_url, parent_id: @league_id)
  end
end
