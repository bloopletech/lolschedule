class Riot::Team
  attr_reader :league_id, :code, :image

  def initialize(data)
    @league_id = data["league_id"]
    @code = data["code"]
    @image = data["image"]
  end

  def id
    "#{league_id}-#{code}"
  end
end
