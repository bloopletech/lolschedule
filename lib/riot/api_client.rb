class Riot::ApiClient
  include Singleton

  HOST = "http://api.lolesports.com"
  MATCHES_ENDPOINT = "/api/v1/scheduleItems?leagueId="
  VIDEOS_ENDPOINT = "/api/v2/videos"
  LIVESTREAM_ENDPOINT = "/api/v2/streamgroups"
  HEADERS = {
    "Accept" => "application/json, text/javascript, */*; q=0.01",
    "Accept-Encoding" => "gzip, deflate, sdch",
    "Accept-Language" => ":en-GB,en;q=0.8,en-US;q=0.6",
    "Connection" => "keep-alive",
    "Origin" => "http://www.lolesports.com",
    "Referer" => "http://www.lolesports.com/en_US/",
    "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36"
  }

  def initialize
    @connection = Excon.new(HOST,
      persistent: true,
      middlewares: Excon.defaults[:middlewares] + [Excon::Middleware::Decompress],
      omit_default_port: true
    )

    @cache = {}
  end

  def request_url(path)
    print "Requesting #{HOST}#{path}..."

    if @cache.key?(path)
      puts " found in cache"
      return @cache[path]
    end

    start = Time.now
    response = @connection.get(path: path, headers: HEADERS)

    taken = ((Time.now - start) * 1000).round(1)
    size_kb = (response.body.bytes.length / 1024.0).round(1)
    puts " done; took #{taken}ms, response status #{response.status}, body size #{size_kb}KB"

    @cache[path] = response.body
  end

  def retrieve(path)
    JSON.parse(request_url(path))
  end

  def matches(league_id)
    retrieve("#{MATCHES_ENDPOINT}#{league_id}")
  end

  def videos
    retrieve(VIDEOS_ENDPOINT)
  end

  def livestreams
    retrieve(LIVESTREAM_ENDPOINT)
  end
end