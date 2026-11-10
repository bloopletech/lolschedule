class Riot::Game
  attr_reader :id, :state, :vod

  def initialize(data)
    @id = data["id"]
    @state = data["state"]
    vods = data["vods"].map.with_index { |vod, i| Riot::Vod.new(vod.merge("id" => "#{@id}-#{i}")) }
    @needs_event_detail = vods.length > 1
    @vod = vods.first unless @needs_event_detail
  end

  def completed?
    @state == "completed"
  end

  def needs_event_detail?
    @needs_event_detail
  end
end
