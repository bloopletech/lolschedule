class Seeders::Leagues
  def initialize(store, riot_data)
    @store = store
    @riot_data = riot_data
  end

  def seed
    @riot_data.leagues.each do |league|
      @store.leagues << Models::League.new(riot_id: league.id, name: league.name)
    end
  end
end