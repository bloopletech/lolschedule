class Riot::Tournament
  def initialize(tournament)
    @tournament = tournament
  end

  def videos
    @videos ||= Riot::ApiClient.instance.videos
  end

  def video(game_id)
    videos['videos'].find { |video| video['game'] == game_id && video['locale'] == 'en' }
  end

  def bracket(bracket_id)
    @tournament['brackets'][bracket_id]
  end

  def bracket_match(bracket, match_id)
    bracket['matches'][match_id]
  end

  def roster(roster_id)
    @tournament['rosters'][roster_id]
  end

  def match(schedule_item)
    bracket = bracket(schedule_item['bracket'])
    bracket_match(bracket, schedule_item['match'])
  end

  def match_teams(match)
    match_rosters = match['input'].map { |input| roster(input['roster']) }

    return nil, nil if match_rosters.any? { |roster| roster.nil? }

    match_rosters.map { |roster| roster['team'].to_i }
  end

  def match_videos(match)
    match['games'].values.sort_by { |game| game['name'] }.map { |game| video(game['id']) }.compact
  end
end