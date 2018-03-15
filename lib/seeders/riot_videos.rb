class Seeders::RiotVideos
  def initialize(source)
    @source = source
    @riot_videos = Riot::Videos.new
  end

  def seed
    @riot_videos.videos.each do |video|
      @source.vods << Models::Vod.new({
        riot_id: video['game'],
        url: Seeders::YoutubeLinkParser.new(find_url(video['source'])).parse
      })
    end
  end

  def find_url(source)
    source =~ /(http.*)/
    $1
  end
end
