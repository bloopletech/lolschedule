class Riot::Tournament
  def initialize(tournament)
    @tournament = tournament
  end

  def bracket(bracket_id)
    @tournament['brackets'][bracket_id]
  end

  def roster(roster_id)
    @tournament['rosters'][roster_id]
  end

  def bracket_match(bracket, match_id)
    bracket['matches'][match_id]
  end

  def match(schedule_item)
    bracket = bracket(schedule_item['bracket'])
    [bracket, bracket_match(bracket, schedule_item['match'])]
  end

  def match_rosters(match)
    match['input'].map { |input| roster(input['roster']) }
  end

  def match_type(match)
    rosters = match_rosters(match)

    return nil if rosters.any? { |roster| roster.nil? }

    rosters.first.key?('team') ? 'team' : 'single'
  end

  def match_teams(match)
    match_participants(match, 'team')
  end

  def match_players(match)
    match_participants(match, 'player')
  end

  def match_participants(match, participant_type)
    rosters = match_rosters(match)

    return nil, nil if rosters.any? { |roster| roster.nil? }

    rosters.map { |roster| roster[participant_type].to_i }
  end

  def match_game_ids(match)
    match['games'].values.sort_by { |game| game['name'] }.map { |game| game['id'] }.compact
  end
end