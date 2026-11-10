class Riot::Stream
  attr_reader :id, :provider, :parameter, :offset, :locale

  def initialize(data)
    @id = data["id"]
    @provider = data["provider"]
    @offset = data["offset"]
    @locale = data["locale"]
  end

  def english?
    locale =~ /^en/
  end

  def youtube?
    provider == "youtube"
  end
end
