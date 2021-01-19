class Build::StreamUrl
  def initialize(attributes)
    @provider = attributes['provider']
    @id = attributes['id']
    @start = attributes['start']
  end

  def to_h
    {
      "id": @id,
      "start": @start,
      "url": url
    }
  end

  def youtube
    url = "https://youtu.be/#{@id}"
    url += "?t=#{@start}" if @start != "0"
    url
  end

  def twitch
    "https://twitch.tv/#{@id}"
  end

  def url
    case @provider
    when "youtube"
      youtube
    when "twitch"
      twitch
    else
      raise
    end
  end
end
