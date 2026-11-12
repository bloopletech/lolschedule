class Riot::Client
  HOST = "https://esports-api.lolesports.com"
  API_KEY = "0TvQnueqKa5mxJntVWt0w4LpLfEkrV1Ta8rQBb9Z"

  def initialize
    @client = Client.new(HOST, { "x-api-key" => API_KEY })
  end

  def get(request)
    body = JSON.parse(@client.get(request.path))
    Riot::Response.new(body, request.league_id)
  end

  def parallel_get(requests)
    Parallel.new(requests).perform_collate { |request| get(request) }
  end
end
    