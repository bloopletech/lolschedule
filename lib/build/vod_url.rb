class Build::VodUrl
  def initialize(attributes)
    @id = attributes['id']
    @start = attributes['start']
  end

  def to_h
    {
      "id": @id,
      "start": @start,
      "youtube": youtube,
      "surprise": surprise
    }
  end

  def youtube
    url = "#{@id}"
    url += "?t=#{@start}" if @start != "0"
    url
  end
  
  def surprise
    "http://surprise.ly/v/?#{@id}:#{@start}:0:0:100"
  end
end