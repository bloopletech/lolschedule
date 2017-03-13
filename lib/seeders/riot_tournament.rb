class Seeders::RiotTournament
  extend Forwardable
  def_delegators :@riot_league, :teams, :schedule_items
  def_delegators :@riot_tournament, :match, :match_type, :match_teams, :match_players, :match_videos

  def initialize(source, riot_league, tournament)
    @source = source
    @riot_league = riot_league
    @tournament = tournament
    @riot_tournament = Riot::Tournament.new(tournament)
  end

  def seed
    schedule_items(@tournament['id']).select { |item| item['bracket'] }.each { |item| seed_item(item) }
  end

  def seed_item(item)
    match = match(item)

    if match_type(match) == 'team'
      seed_team_match(item, match)
    else
      seed_single_match(item, match)
    end
  end

  def seed_team_match(item, match)
    team_ids = match_teams(match)
    return if team_ids.any? { |team_id| team_id.nil? }

    seed_match(item, match, {
      type: 'team',
      riot_team_1_id: team_ids.first,
      riot_team_2_id: team_ids.last
    })
  end

  def seed_single_match(item, match)
    player_ids = match_players(match)
    return if player_ids.any? { |player_id| player_id.nil? }

    seed_match(item, match, {
      type: 'single',
      riot_player_1_id: player_ids.first,
      riot_player_2_id: player_ids.last
    })
  end

  def seed_match(item, match, attrs)
    vod_urls = match_videos(match).map { |video| video['source'] }
    vod_urls.map! { |url| Seeders::YoutubeLinkParser.new(url).parse }
    vod_urls.compact!

    @source.matches << Models::Match.new({
      riot_id: match['id'],
      riot_league_id: @tournament['league'],
      time: item['scheduledTime'],
      vod_urls: vod_urls
    }.merge(attrs))
  end
end