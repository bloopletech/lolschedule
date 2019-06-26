class Seeders::RiotTournament
  extend Forwardable
  def_delegators :@riot_league, :teams, :schedule_items
  def_delegators :@riot_tournament, :match, :match_type, :match_teams, :match_players, :match_game_ids, :spoiler_bracket?

  def initialize(source, riot_league, tournament)
    @source = source
    @riot_league = riot_league
    @tournament = tournament
    @riot_tournament = Riot::Tournament.new(tournament)
  end

  def seed
    schedule_items(@tournament['id']).select { |item| item['bracket'] }.each { |item| seed_item(item) }
  end

  def seed_item(schedule_item)
    bracket, match = match(schedule_item)

    attrs = {
      bracket_name: bracket['name']
    }

    if match_type(match) == 'team'
      seed_team_match(schedule_item, match, attrs)
    else
      seed_single_match(schedule_item, match, attrs)
    end
  end

  def seed_team_match(item, match, attrs)
    team_ids = match_teams(match)
    return if team_ids.any? { |team_id| team_id.nil? }

    seed_match(item, match, attrs.merge({
      type: 'team',
      riot_team_1_id: team_ids.first,
      riot_team_2_id: team_ids.last
    }))
  end

  def seed_single_match(item, match, attrs)
    player_ids = match_players(match)
    return if player_ids.any? { |player_id| player_id.nil? }

    seed_match(item, match, attrs.merge({
      type: 'single',
      riot_player_1_id: player_ids.first,
      riot_player_2_id: player_ids.last
    }))
  end

  def seed_match(item, match, attrs)
    @source.matches << Models::Match.new({
      riot_id: match['id'],
      riot_league_id: item['league'],
      time: item['scheduledTime'],
      riot_game_ids: match_game_ids(match)
    }.merge(attrs))
  end
end