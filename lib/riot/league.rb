class Riot::League
  LEAGUES_ENDPOINT = "/persisted/gw/getLeagues?hl=en-US"
  TOURNAMENTS_ENDPOINT = "/persisted/gw/getTournamentsForLeague?hl=en-US&leagueId="
  SCHEDULES_ENDPOINT = "/persisted/gw/getSchedule?hl=en-US&leagueId="

  attr_reader :id, :name

  def self.request
    Riot::Request.new(LEAGUES_ENDPOINT)
  end

  def self.parse(response)
    leagues = response.body.dig!("data", "leagues")
    leagues.map { |league| new(league) }
  end

  def initialize(data)
    @id = data.dig!("id")
    @name = data.dig!("name")
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
    Riot::Request.new(tournament_url, id)
  end

  def schedule_request(page_token = nil)
    Riot::Request.new(schedule_url(page_token), id)
  end
end
