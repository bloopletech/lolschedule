class Riot::Data
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

  MUTEX = Mutex.new

  def self.seed_urls
    urls = {
      "livestreams" => Riot::ApiClient::LIVESTREAM_ENDPOINT,
      "videos" => Riot::ApiClient::VIDEOS_ENDPOINT
    }

    LEAGUES.keys.each do |league_id|
      urls["league_#{league_id}"] = "#{Riot::ApiClient::MATCHES_ENDPOINT}#{league_id}"
    end

    urls
  end

  def self.seed
    puts "Requesting data..."

    @data = {}
    client = Riot::ApiClient.new

    threads = seed_urls.map do |(key, url)|
      Thread.new do
        response = client.retrieve(url)
        MUTEX.synchronize { @data[key] = response }
      end
    end

    threads.each { |thread| thread.join }
  end

  def self.[](key)
    @data[key]
  end
end