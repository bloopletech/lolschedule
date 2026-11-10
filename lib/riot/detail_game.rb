class Riot::DetailGame
  attr_reader :id, :state, :vod

  def initialize(data)
    @id = data["id"]
    @state = data["state"]
    vods = data["vods"].map { |vod| Riot::DetailVod.new(vod) }.select { |vod| vod.youtube? }
    @vod = vods.find { |vod| vod.english? } || vods.first
  end

  def completed?
    @state == "completed"
  end
end
