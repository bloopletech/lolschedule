class Riot::Request
  attr_reader :path, :league_id

  def initialize(url, league_id = nil)
    @path = url
    @league_id = league_id
  end
end
