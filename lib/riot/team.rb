class Riot::Team
  def initialize(data)
    @data = data
  end

  def league_id
    @data["league_id"]
  end

  def id
    "#{league_id}-#{code}"
  end

  def code
    @data["code"]
  end

  def image
    @data["image"]
  end
end
