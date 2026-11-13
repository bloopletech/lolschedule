class Riot::Stream
  attr_reader :provider, :parameter, :offset, :locale

  def initialize(data)
    @provider = data.dig!("provider")
    @parameter = data.dig!("parameter")
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
