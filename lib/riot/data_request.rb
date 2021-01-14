class Riot::DataRequest
  API_KEY = "0TvQnueqKa5mxJntVWt0w4LpLfEkrV1Ta8rQBb9Z"

  attr_reader :url, :parent_id

  def initialize(url:, parent_id:)
    @url = url
    @parent_id = parent_id
  end

  def get
    body = JSON.parse(Client.get(@url, API_KEY))
    Riot::DataResponse.new(data_request: self, body: body)
  end
end
