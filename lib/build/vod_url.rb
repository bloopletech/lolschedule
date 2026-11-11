class Build::VodUrl
  def initialize(attributes)
    @provider = attributes['provider']
    @id = attributes['id']
    @start = attributes['start']
  end

  def to_h
    {
      "id": @id,
      "start": @start,
      "url": url,
      "surprise": @provider == "youtube" ? surprise : nil
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

  def surprise
    "http://surprise.ly/v/?#{@id}:#{@start}:0:0:100"
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