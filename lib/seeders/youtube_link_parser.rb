class Seeders::YoutubeLinkParser
  def initialize(url)
    @url = Addressable::URI.parse(url)
  end

  def parse
    return nil if @url.nil? || @url.empty?

    if @url.path =~ %r{^/embed/}
      parse_embed
    elsif @url.path =~ %r{/watch}
      parse_watch
    else
      raise "URL #{@url} is not a valid Youtube link"
    end
  end

  def parse_embed
    video_id = @url.basename
    start_time = (@url.query_values && @url.query_values["start"]) || "0"

    { id: video_id, start: start_time }
  end

  def parse_watch
    params = @url.query_values
    video_id = params["v"]
    start_time = params["start"] || "0"

    { id: video_id, start: start_time }
  end
end