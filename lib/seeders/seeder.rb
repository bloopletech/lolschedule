class Seeders::Seeder
  def initialize(source)
    @source = source
  end

  def seed
    Riot::Data.seed

    Seeders::Leagues.new(@source).seed

    Seeders::Tournaments.new(@source).seed

    Seeders::Events.new(@source).seed

    # Seeders::RiotStreams.new(@source).seed
    # 
    # @source.leagues.each do |league|
    #   Seeders::RiotLeague.new(@source, league.riot_id).seed
    # end
  end
end