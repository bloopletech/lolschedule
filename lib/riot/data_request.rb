class Riot::DataRequest
  API_KEY = "0TvQnueqKa5mxJntVWt0w4LpLfEkrV1Ta8rQBb9Z"

  attr_reader :url, :league_id

  def initialize(url:, league_id: nil)
    @url = url
    @league_id = league_id
  end

  def get
    body = JSON.parse(Client.get(@url, API_KEY))
    Riot::DataResponse.new(body:, league_id:)
  end
end
