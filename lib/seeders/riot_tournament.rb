class Seeders::RiotTournament
  extend Forwardable
  def_delegators :@riot_league, :teams, :schedule_items
  def_delegators :@riot_tournament, :match, :match_teams, :match_videos

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
    team_ids = match_teams(match)
    game_urls = match_videos(match).map { |video| video['source'] }

=begin
    stream_matches = league_hash[:stream_matches]
    stream_url = nil
    if stream_matches && stream_matches.include?(match['id'])
      stream_url = league_hash[:stream_url]
    end
=end
    @source.matches << Models::Match.new(
      riot_id: match['id'],
      riot_league_id: @tournament['league'],
      riot_team_1_id: team_ids.first,
      riot_team_2_id: team_ids.last,
      time: item['scheduledTime'],
      game_urls: game_urls
      #stream_url: stream_url
    )
  end
end