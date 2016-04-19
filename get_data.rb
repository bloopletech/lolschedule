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

USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36'

def request_url(url)
  start = Time.now
  body = URI.parse(url).read("User-Agent" => USER_AGENT)
  puts "Requested #{url}, took #{((Time.now - start) * 1000).round(1)}ms, body size #{(body.bytes.length / 1024.0).round(1)}KB"
  body
end

def parse_streams
  json = JSON.parse(request_url('http://api.lolesports.com/api/v2/streamgroups'))

  json['streamgroups'].each do |group|
    next unless group['live']
    next

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

def parse_league(league_hash, league_name)
  league = JSON.parse(request_url("http://api.lolesports.com/api/v1/scheduleItems?leagueId=#{league_hash[:id]}"))

  league_hash[:teams] = {}
  league['teams'].each do |team|
    league_hash[:teams][team['acronym']] = { logo: team['logoUrl'] }
  end

  league['highlanderTournaments'].select { |t| t['published'] }.each do |tournament|
    videos = JSON.parse(request_url("http://api.lolesports.com/api/v2/videos?tournament=#{CGI::escape(tournament['id'])}"))

    scheduleItems = league['scheduleItems'].select { |s| s['tournament'] == tournament['id'] }

    scheduleItems.select { |item| item['bracket'] }.each do |item|
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

      stream_matches = league_hash[:stream_matches]
      stream_url = nil
      if stream_matches && stream_matches.include?(match['id'])
        stream_url = league_hash[:stream_url]
      end
      
      Data::Match.create(
        league_name: league_name,
        time: item['scheduledTime'],
        vs: vs,
        game_urls: game_urls,
        stream_url: stream_url
      )
    end
  end
end

$data = { leagues: {}, matches: [] }

LEAGUES.each_pair do |league_id, league_name|
  league_hash = { id: league_id }
  $data[:matches] += parse_league(league_hash, league_name)
  $data[:leagues][league_name] = league_hash
end

$data[:matches].sort_by! { |s| Time.parse(s[:time]) } }

File.open('build/data.json', 'w') { |f| f << $data.to_json }
