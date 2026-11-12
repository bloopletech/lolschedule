class Build::VodUrl
  TWITCH_VOD_EXPIRY = 2600 * 24 * 30

  def initialize(vod)
    @provider = vod.provider
    @id = vod.id
    @start = vod.start
  end

  def to_h
    {
      "id": @id,
      "start": @start,
      "url": url,
      "surprise": @provider == "youtube" ? surprise : nil
    }
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

  def youtube
    url = "https://youtu.be/#{@id}"
    url += "?t=#{@start}" if @start != "0"
    url
  end

  def twitch
    "https://twitch.tv/videos/#{@id}"
  end

  def surprise
    "http://surprise.ly/v/?#{@id}:#{@start}:0:0:100"
  end

  def expired?(match_time)
    @provider == "twitch" && (Time.now - match_time).to_r > TWITCH_VOD_EXPIRY
  end
end