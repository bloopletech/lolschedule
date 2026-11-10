class Riot::Game
  attr_reader :id, :state, :vods

  def initialize(data)
    @id = data["id"]
    @state = data["state"]
    @vods = data["vods"].map { |vod| Riot::Vod.new(vod) }.select { |vod| vod.english? && vod.youtube? }
  end

  def completed?
    @state == "completed"
  end
end
