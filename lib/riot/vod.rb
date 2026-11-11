class Riot::Vod
  attr_reader :id, :locale, :provider, :parameter, :offset

  def initialize(data)
    @id = data["id"]
    @locale = data["locale"]
    @parameter = data["parameter"]
    @provider = data["provider"] || (@parameter =~ /^\d+$/ ? "twitch" : "youtube")
    @offset = data["offset"] || 0
  end

  def english?
    locale =~ /^en/
  end

  def youtube?
    provider == "youtube"
  end
end
