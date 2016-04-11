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
  '13' => 'OPL',
  '4' => 'NA CS',
  '5' => 'EU CS'
}

def request_url(url)
  start = Time.now
  body = URI.parse(url).read
  puts "Requested #{url}, took #{((Time.now - start) * 1000).round(1)}ms, body size #{(body.bytes.length / 1024.0).round(1)}KB"
  body
end

def parse_streams
  json = JSON.parse(request_url('http://api.lolesports.com/api/v2/streamgroups'))

  json['streamgroups'].each do |group|
    next unless group['live']

    streams = json['streams'].select { |stream| stream['streamgroups'].any? { |id| id == group['id'] } }
    stream = streams.find { |stream| stream['provider'] == 'youtube' }
    next unless stream

    stream['embedHTML'] =~ /(https:\/\/www\.youtube\.com)(.*?)"/
    url = "#{$1}#{$2}"

    league_id = LEAGUES.key(group['title'].gsub(' English', ''))
    $leagues[league_id].merge!(stream_url: url) if league_id
  end

  json['highlanderTournaments'].each do |tournament|
    next unless $leagues[tournament['league']]
    $leagues[tournament['league']].merge!(stream_matches: tournament['liveMatches'])
  end
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

      next if match_rosters.any? { |roster| roster.nil? }

      match_teams = match_rosters.map do |roster|
        league['teams'].find { |team| team['id'] == roster['team'].to_i }
      end

      vs = match_teams.map { |team| team['acronym'] }

      game_urls = match['games'].values.sort_by { |game| game['name'] }.map do |game|
        video = videos['videos'].find { |video| video['game'] == game['id'] }
        video['source'] if video
      end.compact

      match_hash = {
        time: item['scheduledTime'],
        vs: vs,
        game_urls: game_urls
      }

      stream_matches = $leagues[league_id][:stream_matches]
      if stream_matches && stream_matches.include?(match['id'])
        match_hash[:stream_url] = $leagues[league_id][:stream_url]
      end

      match_hash
    end
  end

  $leagues[league_id].merge!(
    teams: teams,
    matches: matches.compact
  )
end

$leagues = {}
LEAGUES.each_pair { |league_id, league_name| $leagues[league_id] = { name: league_name } }

parse_streams
$leagues.keys.each { |league_id| parse_league(league_id) }

data = Hash[$leagues.values.map { |league| [league[:name], league] }]

=begin
table = [data.keys]
rows = data.values.map { |l| l[:matches].length }.max - 1
0.upto(rows) do |row|
  table << data.keys.map { |league_name| data[league_name][:matches][row] }
end
=end

File.open('build/data.json', 'w') { |f| f << data.to_json }
