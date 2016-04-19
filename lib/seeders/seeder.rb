class Seeders::Seeder
  def initialize(source)
    @source = source
  end

  def seed
    Seeders::League.new(@source).seed
    
    @source.leagues.each do |league|
      Seeders::RiotLeague.new(@source, league.riot_id).seed
    end
  end
end