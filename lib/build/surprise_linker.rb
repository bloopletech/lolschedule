class Build::SurpriseLinker
  def initialize(url)
    @url = Addressable::URI.parse(url)
  end

  def link
    return "" if @url.empty?

    link_info = if @url.path =~ %r{^/embed/}
      embed_link
    elsif @url.path =~ %r{/watch}
      watch_link
    else
      raise "URL #{@url} is not a valid Youtube link"
    end

    "http://surprise.ly/v/?#{link_info[:video_id]}:#{link_info[:start_time]}:0:0:100"
  end

  def embed_link
    video_id = @url.basename
    params = @url.query_values
    start_time = params["start"] || "0"

    { video_id: video_id, start_time: start_time }
  end

  def watch_link
    params = @url.query_values
    video_id = params["v"]
    start_time = params["start"] || "0"

    { video_id: video_id, start_time: start_time }
  end
end