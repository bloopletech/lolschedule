class Seeders::RiotStreams
  STREAMGROUPS_LEAGUES = {
    'msi' => 'MSI',
    'nalcs1' => 'NA LCS',
    'nalcs-2' => 'NA LCS',
    'eulcs1' => 'EU LCS',
    'eulcs-2' => 'EU LCS',
    'lck-korea' => 'LCK',
    'lck' => 'LCK',
    'lpl' => 'LPL',
    'lms' => 'LMS',
    'oce-opl' => 'OPL',
    'na-challenger' => 'NA CS',
    'eu-challenger' => 'EU CS',
    'worldchampionship' => 'Worlds',
    'altstream' => 'Worlds'
  }

  extend Forwardable
  def_delegators :@riot_streams, :active_streamgroups, :streams, :youtube_streams, :active_matches

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
      streams = youtube_streams(streams(streamgroup['id']))

      riot_league_id = stream_league_id(streamgroup['slug'])

      streams.each do |stream|
        next unless stream && riot_league_id

        seed_stream(
          stream: stream,
          title: streamgroup['title'],
          slug: streamgroup['slug'],
          riot_league_id: riot_league_id
        )
      end
    end
  end

  def seed_stream(stream:, title:, slug:, riot_league_id:)
    stream['embedHTML'] =~ /(https:\/\/www\.youtube\.com)(.*?)"/
    url = "#{$1}#{$2}"

    stream_title = if title =~ /\d+/
      title[/\d+/]
    elsif stream['title'] =~ /-/
      stream['title'][/- (.*?)$/, 1]
    elsif slug == 'altstream'
      "- #{title}"
    else
      nil
    end

    priority = stream_title == 'OGN' || stream_title.nil?

    league = @source.leagues.find(riot_league_id)
    league.streams << { 'id' => stream_title, 'url' => url, priority: priority }
  end

  def seed_active_matches
    active_matches.each_pair do |riot_league_id, match_ids|
      league = @source.leagues.find(riot_league_id)
      league.stream_match_ids = match_ids if league
    end
  end

  def stream_league_id(slug)
    Seeders::League::LEAGUES.key(STREAMGROUPS_LEAGUES[slug])
  end
end