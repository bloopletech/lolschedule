class Riot::Stream
  def initialize(data)
    @data = data
  end

  def id
    @data["id"]
  end

  def provider
    @data["provider"]
  end

  def parameter
    @data["parameter"]
  end

  def offset
    @data["offset"]
  end

  def locale
    @data["locale"]
  end

  def english?
    locale == "en-US"
  end
end
