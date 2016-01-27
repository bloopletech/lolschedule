require 'open-uri'
require 'json'
require 'time'
require 'cgi'

LEAGUES = {
  '2' => 'NA LCS',
  '3' => 'EU LCS',
  '6' => 'LCK',
  '7' => 'LPL',
  '8' => 'LMS',
  '1' => 'All-Star',
  '9' => 'World Championship'
}

def request_url(url)
  start = Time.now
  body = URI.parse(url).read
  puts "Requested #{url}, took #{((Time.now - start) * 1000).round(1)}ms, body size #{(body.bytes.length / 1024.0).round(1)}KB"
  body
end

def parse_league(league_id)
  league = JSON.parse(request_url("http://api.lolesports.com/api/v1/scheduleItems?leagueId=#{league_id}"))

  teams = Hash[league['teams'].map do |team|
    [team['acronym'], { logo: team['logoUrl'] }]
  end]

  league['scheduleItems'].sort_by! { |s| Time.parse(s['scheduledTime']) }

  matches = []

  league['highlanderTournaments'].select { |t| t['published'] }.each do |tournament|
    videos = JSON.parse(request_url("http://api.lolesports.com/api/v2/videos?tournament=#{CGI::escape(tournament['id'])}"))

    scheduleItems = league['scheduleItems'].select { |s| s['tournament'] == tournament['id'] }

    matches += scheduleItems.select { |item| item['bracket'] }.map do |item|
      bracket = tournament['brackets'][item['bracket']]
      match = bracket['matches'][item['match']]

      match_rosters = match['input'].map do |input|
        tournament['rosters'][input['roster']]
      end

      match_teams = match_rosters.map do |roster|
        league['teams'].find { |team| team['id'] == roster['team'].to_i }
      end

      vs = match_teams.map { |team| team['acronym'] }

      game_urls = match['games'].keys.map do |game_id|
        video = videos['videos'].find { |video| video['game'] == game_id }
        video['source'] if video
      end.compact

      {
        time: item['scheduledTime'],
        vs: vs,
        game_urls: game_urls
      }
    end
  end

  {
    teams: teams,
    matches: matches
  }
end

data = {}
%w(2 3 6 7 8).each do |league_id|
  data[LEAGUES[league_id]] = parse_league(league_id)
end

=begin
table = [data.keys]
rows = data.values.map { |l| l[:matches].length }.max - 1
0.upto(rows) do |row|
  table << data.keys.map { |league_name| data[league_name][:matches][row] }
end
=end

=begin
rosters = match['input'].map do |input|
  tournament['rosters'][input['roster']]
end
=end

File.open('data.json', 'w') { |f| f << data.to_json }