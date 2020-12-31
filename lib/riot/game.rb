class Riot::Game
  def initialize(data)
    @data = data
  end

  def id
    @data["id"]
  end

  def vods
    @data["vods"].map.with_index do |vod, i|
      Riot::Vod.new(vod.merge("id" => "#{id}-#{i}"))
    end
  end
end
