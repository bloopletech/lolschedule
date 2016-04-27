class Seeders::RiotStreams
  extend Forwardable
  def_delegators :@riot_streams, :active_streamgroups, :streams, :youtube_stream, :active_matches

  def initialize(source)
    @source = source
    @riot_streams = Riot::Streams.new
  end

  def seed
    seed_streams
    seed_active_matches
  end
  
  def seed_streams
    active_streamgroups.each do |streamgroup|
      stream = youtube_stream(streams(streamgroup['id']))

      seed_stream(stream) if stream
    end
  end

  def seed_stream(stream)
    stream['embedHTML'] =~ /(https:\/\/www\.youtube\.com)(.*?)"/
    url = "#{$1}#{$2}"

    riot_league_id = Seeders::LEAGUES.key(group['title'].gsub(' English', ''))
    
    if riot_league_id
      league = @source.leagues.find { |league| league.riot_id == riot_league_id }
      league.stream_url = url
    end
  end

  def seed_active_matches
    active_matches.each_pair do |riot_league_id, match_ids|
      league = @source.leagues.find { |league| league.riot_id == riot_league_id }
      league.stream_match_ids = match_ids
    end
  end
end