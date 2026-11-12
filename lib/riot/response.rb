class Riot::Response
  attr_reader :body, :league_id
  
  def initialize(body, league_id)
    @body = body
    @league_id = league_id
  end
end
