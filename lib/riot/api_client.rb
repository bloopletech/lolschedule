class Riot::ApiClient
  USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36'
  ROOT_ENDPOINT = "http://api.lolesports.com/api"
  MATCHES_ENDPOINT = "#{ROOT_ENDPOINT}/v1/scheduleItems?leagueId="
  VIDEOS_ENDPOINT = "#{ROOT_ENDPOINT}/v2/videos?tournament="
  LIVESTREAM_ENDPOINT = "#{ROOT_ENDPOINT}/v2/streamgroups"

  def self.request_url(url)
    start = Time.now
    print "Requesting #{url}..."
    body = URI.parse(url).read("User-Agent" => USER_AGENT)
    puts " done; took #{((Time.now - start) * 1000).round(1)}ms, body size #{(body.bytes.length / 1024.0).round(1)}KB"
    body
  end

  def self.retrieve(url)
    JSON.parse(request_url(url))
  end

  def self.matches(league_id)
    retrieve("#{MATCHES_ENDPOINT}#{league_id}")
  end

  def self.videos(tournament_id)
    retrieve("#{VIDEOS_ENDPOINT}#{CGI::escape(tournament_id)}")
  end

  def self.livestreams
    retrieve(LIVESTREAM_ENDPOINT)
  end
end