class Riot::League
  HOST = "https://esports-api.lolesports.com"
  TOURNAMENTS_ENDPOINT = "#{HOST}/persisted/gw/getTournamentsForLeague?hl=en-US&leagueId="
  SCHEDULES_ENDPOINT = "#{HOST}/persisted/gw/getSchedule?hl=en-US&leagueId="

  def self.parse(response)
    leagues = response.body["data"]["leagues"]
    leagues.map { |league| new(league) }
  end

  def initialize(data)
    @data = data
  end

  def id
    @data["id"]
  end

  def name
    @data["name"]
  end

  def tournament_url
    "#{TOURNAMENTS_ENDPOINT}#{id}"
  end

  def schedule_url(page_token = nil)
    if page_token
      "#{SCHEDULES_ENDPOINT}#{id}&pageToken=#{page_token}"
    else
      "#{SCHEDULES_ENDPOINT}#{id}"
    end
  end

  def tournament_request
    Riot::DataRequest.new(url: tournament_url, parent_id: id)
  end

  def schedule_request(page_token = nil)
    Riot::DataRequest.new(url: schedule_url(page_token), parent_id: id)
  end
end
