class Riot::EventDetail
  attr_reader :league_id, :id, :games

  def self.parse(data_response)
    new(data_response.body["data"]["event"])
  end

  def initialize(data)
    @league_id = data["league"]["id"]
    @id = data["id"]
    @games = data["match"]["games"].map { |game| Riot::DetailGame.new(game) }.select { |game| game.completed? }
  end
end
