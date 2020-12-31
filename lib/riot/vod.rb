class Riot::Vod
  def initialize(data)
    @data = data
  end

  def id
    @data["id"]
  end

  def parameter
    @data["parameter"]
  end
end
