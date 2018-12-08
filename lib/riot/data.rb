class Riot::Data
  HOST = "http://api.lolesports.com"
  MATCHES_ENDPOINT = "#{HOST}/api/v1/scheduleItems?leagueId="
  VIDEOS_ENDPOINT = "#{HOST}/api/v2/videos"
  LIVESTREAM_ENDPOINT = "#{HOST}/api/v2/streamgroups"

  LEAGUES = {
    '1' => 'All-Star',
    '9' => 'Worlds',
    '43' => 'Rivals',
    '10' => 'MSI',
    '2' => 'NA LCS',
    '3' => 'EU LCS',
    '6' => 'LCK',
    '7' => 'LPL',
    '8' => 'LMS',
    '4' => 'NA CS',
    '5' => 'EU CS'
  }

  def self.seed_urls
    urls = {
      LIVESTREAM_ENDPOINT => "livestreams",
      VIDEOS_ENDPOINT => "videos"
    }

    LEAGUES.keys.each do |league_id|
      urls["#{MATCHES_ENDPOINT}#{league_id}"] = "league_#{league_id}"
    end

    urls
  end

  def self.seed
    SyncedStdout.puts "Requesting data..."

    urls_keys = seed_urls
    responses = Parallel.new(urls_keys.keys).perform_collate { |url| JSON.parse(Client.get(url)) }

    @data = responses.transform_keys { |url| urls_keys[url] }
  end

  def self.[](key)
    @data[key]
  end
end