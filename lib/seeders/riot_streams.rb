class Seeders::RiotStreams
  STREAMGROUPS_LEAGUES = {
    'msi' => 'MSI',
    'na-lcs' => 'NA LCS',
    'nalcs2' => 'NA LCS',
    'eu-lcs' => 'EU LCS',
    'eulcs2' => 'EU LCS',
    'lck-korea' => 'LCK',
    'lck' => 'LCK',
    'lpl' => 'LPL',
    'lms' => 'LMS',
    'oce-opl' => 'OPL',
    'na-challenger' => 'NA CS',
    'eu-challenger' => 'EU CS'
  }

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

      riot_league_id = stream_league_id(streamgroup['slug'])

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
      league.stream_match_ids = match_ids if league
    end
  end

  def stream_league_id(slug)
    Seeders::League::LEAGUES.key(STREAMGROUPS_LEAGUES[slug])
  end
end