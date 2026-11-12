class Riot::Stream
  attr_reader :id, :provider, :parameter, :offset, :locale

  def initialize(data)
    @id = data.dig!("id")
    @provider = data.dig!("provider")
    @offset = data.dig!("offset")
    @locale = data.dig!("locale")
  end

  def english?
    locale =~ /^en/
  end

  def youtube?
    provider == "youtube"
  end
end
