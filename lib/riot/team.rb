class Riot::Team
  attr_reader :league_id, :code, :image

  def initialize(data)
    @league_id = data.dig!("league_id")
    @code = data.dig!("code")
    @image = data.dig!("image")
  end

  def id
    "#{league_id}-#{code}"
  end
end
