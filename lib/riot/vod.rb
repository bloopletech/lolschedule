class Riot::Vod
  attr_reader :locale, :parameter

  def initialize(data)
    @provider = data["provider"]
    @parameter = data.dig!("parameter")
    @offset = data["offset"]
    @locale = data["locale"]
  end

  def provider
    @provider || (@parameter =~ /^\d+$/ ? "twitch" : "youtube")
  end

  def offset
    @offset || 0
  end

  def english?
    locale =~ /^en/
  end

  def youtube?
    provider == "youtube"
  end
end
