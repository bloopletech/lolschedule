class Seeders::RiotVideos
  def initialize(source)
    @source = source
    @riot_videos = Riot::Videos.new
  end

  def seed
    @riot_videos.videos.each do |video|
      @source.vods << Models::Vod.new({
        riot_id: video['game'],
        url: Seeders::YoutubeLinkParser.new(video['source']).parse
      })
    end
  end
end
