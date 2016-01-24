require 'open-uri'
require 'json'
require 'time'

LEAGUES = {
  '2' => 'NA LCS',
  '3' => 'EU LCS',
  '6' => 'LCK',
  '7' => 'LPL',
  '8' => 'LMS',
  '1' => 'All-Star',
  '9' => 'World Championship'
}

def parse_league(league_id)
  body = URI.parse("http://api.lolesports.com/api/v1/scheduleItems?leagueId=#{league_id}").read
  #body = File.read('scheduleItems.json')
  si = JSON.parse(body)

  tournament = si['highlanderTournaments'].find { |t| t['published'] }

  scheduleItems = si['scheduleItems'].select { |s| s['tournament'] == tournament['id'] }
  scheduleItems.sort_by! { |s| Time.parse(s['scheduledTime']) }

  matches = scheduleItems.select { |item| item['bracket'] }.map do |item|
    bracket = tournament['brackets'][item['bracket']]
    match = bracket['matches'][item['match']]
    vs = match['name'].split('-') - ['vs']

    {
      time: item['scheduledTime'],
      vs: vs
    }
  end

  {
    tournament_name: tournament['description'],
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

File.open('data.json', 'w') { |f| f << data.to_json }