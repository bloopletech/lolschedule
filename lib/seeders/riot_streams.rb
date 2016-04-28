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

      riot_league_id = Seeders::League::LEAGUES.key(streamgroup['title'].gsub(' English', ''))

      seed_stream(stream, riot_league_id) if stream && riot_league_id
    end
  end

  def seed_stream(stream, riot_league_id)
    stream['embedHTML'] =~ /(https:\/\/www\.youtube\.com)(.*?)"/
    url = "#{$1}#{$2}"

    league = @source.leagues.find { |league| league.riot_id == riot_league_id }
    league.stream_url = url
  end

  def seed_active_matches
    active_matches.each_pair do |riot_league_id, match_ids|
      league = @source.leagues.find { |league| league.riot_id == riot_league_id }
      league.stream_match_ids = match_ids
    end
  end
end