class Riot::Vod
  attr_reader :id, :parameter, :offset

  def initialize(data)
    @id = data["id"]
    @parameter = data["parameter"]
    @offset = data["offset"]
  end
end
