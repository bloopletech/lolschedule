class Riot::Vod
  attr_reader :id, :locale, :provider, :parameter, :offset

  def initialize(data)
    @id = data["id"]
    @locale = data["locale"]
    @provider = data["provider"]
    @parameter = data["parameter"]
    @offset = data["offset"]
  end

  def english?
    locale =~ /^en/
  end

  def youtube?
    provider == "youtube"
  end
end
