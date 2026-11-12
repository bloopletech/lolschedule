class Seeders::Seeder
  def initialize(store, riot_data)
    @store = store
    @riot_data = riot_data
  end

  def seed
    Seeders::Leagues.new(@store, @riot_data).seed
    Seeders::Events.new(@store, @riot_data).seed
    Seeders::StreamEvents.new(@store, @riot_data).seed
  end
end