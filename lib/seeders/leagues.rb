class Seeders::Leagues
  def initialize(source, riot_data)
    @source = source
    @riot_data = riot_data
  end

  def seed
    @riot_data.leagues.each do |league|
      @source.leagues << Models::League.new(riot_id: league.id, name: league.name)
    end
  end
end