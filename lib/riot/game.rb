class Riot::Game
  attr_reader :id, :state, :vods

  def initialize(data)
    @id = data["id"]
    @state = data["state"]
    @vods = data["vods"].map { |vod| Riot::Vod.new(vod) }
  end

  def completed?
    @state == "completed"
  end

  def needs_event_detail?
    @vods.length > 1
  end
end
