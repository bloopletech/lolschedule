class Riot::Game
  def initialize(data)
    @data = data
  end

  def id
    @data["id"]
  end

  def state
    @data["state"]
  end

  def completed?
    state == "completed"
  end

  def vods
    @data["vods"].take(1).map.with_index do |vod, i|
      Riot::Vod.new(vod.merge("id" => "#{id}-#{i}"))
    end
  end
end
