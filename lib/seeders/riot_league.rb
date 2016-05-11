class Seeders::RiotLeague
  extend Forwardable
  def_delegators :@riot_league, :teams, :published_tournaments

  def initialize(source, riot_league_id)
    @source = source
    @riot_league_id = riot_league_id
    @riot_league = Riot::League.new(@riot_league_id)
  end

  def seed
    seed_teams

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
end
