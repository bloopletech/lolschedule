class Seeders::RiotLeague
  extend Forwardable
  def_delegators :@riot_league, :teams, :players, :published_tournaments

  def initialize(source, riot_league_id)
    @source = source
    @riot_league_id = riot_league_id
    @riot_league = Riot::League.new(@riot_league_id)
  end

  def seed
    seed_teams
    seed_players

    published_tournaments.each do |tournament|
      Seeders::RiotTournament.new(@source, @riot_league, tournament).seed
    end
  end

  def seed_teams
    teams.each do |team|
      @source.teams << Models::Team.new(
        riot_id: team['id'],
        riot_league_id: @riot_league_id,
        acronym: team['acronym'],
        logo: team['logoUrl']
      )
    end
  end

  def seed_players
    players.each do |player|
      @source.players << Models::Player.new(
        riot_id: player['id'],
        riot_league_id: @riot_league_id,
        name: player['name']
      )
    end
  end
end
