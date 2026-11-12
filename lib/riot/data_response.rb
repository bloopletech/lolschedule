class Riot::DataResponse
  attr_reader :body, :parent_id
  
  def initialize(body:, parent_id:)
    @body = body
    @parent_id = parent_id
  end
end
