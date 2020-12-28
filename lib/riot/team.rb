class Riot::Team
  def initialize(data)
    @data = data
  end

  def code
    @data["code"]
  end

  def image
    @data["image"]
  end
end
