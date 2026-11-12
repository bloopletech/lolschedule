class Client
  MUTEX = Mutex.new

  HEADERS = {
    "Accept-Encoding" => "gzip, deflate, sdch",
    "Accept-Language" => ":en-GB,en;q=0.8,en-US;q=0.6",
    "Connection" => "keep-alive",
    "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36"
  }

  def initialize(site, headers = {})
    @site = site
    @connection = Excon.new(
      site,
      middlewares: Excon.defaults[:middlewares] + [Excon::Middleware::Decompress],
      omit_default_port: true,
      headers: HEADERS.merge(headers)
    )
  end

  def get(path)
    start = Time.now

    response = @connection.get(path: path)

    taken = ((Time.now - start) * 1000).round(1)
    size_kb = (response.body.bytes.length / 1024.0).round(1)
    SyncedStdout.puts "Requested #{@site}#{path}; took #{taken}ms, response status #{response.status}, body size #{size_kb}KB"

    response.body
  end

  def self.for(site)
    MUTEX.synchronize do
      @connections ||= {}
      @connections[site] ||= new(site)
    end
  end

  def self.get(url, api_key = nil)
    parsed = Addressable::URI.parse(url)
    self.for(parsed.site).get(parsed.request_uri, api_key)
  end
end