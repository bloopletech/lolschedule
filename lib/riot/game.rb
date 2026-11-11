class Riot::Game
  attr_reader :id, :state, :vods

  def initialize(data)
    @id = data["id"]
    @state = data["state"]
    @vods = data["vods"].map.with_index { |vod, i| Riot::Vod.new({ "id" => "#{@id}-#{i}" }.merge(vod)) }
    @needs_event_detail = vods.length > 1
  end

  def completed?
    @state == "completed"
  end

  def needs_event_detail?
    @needs_event_detail
  end
end
