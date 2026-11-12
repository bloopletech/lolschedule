class Riot::Vod
  attr_reader :id, :locale, :parameter

  def initialize(data)
    @id = data["id"]
    @locale = data["locale"]
    @parameter = data["parameter"]
    @provider = data["provider"]
    @offset = data["offset"]
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
