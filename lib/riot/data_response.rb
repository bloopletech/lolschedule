class Riot::DataResponse
  attr_reader :data_request, :body
  
  def initialize(data_request:, body:)
    @data_request = data_request
    @body = body
  end

  def parent_id
    @data_request.parent_id
  end
end
