class Riot::EventDetail
  attr_reader :league_id, :id, :games

  def self.parse(response)
    new(response.body.dig!("data", "event"))
  end

  def initialize(data)
    @league_id = data.dig!("league", "id")
    @id = data.dig!("id")
    @games = data.dig!("match", "games").map { |game| Riot::Game.new(game) }.select { |game| game.completed? }
  end
end
