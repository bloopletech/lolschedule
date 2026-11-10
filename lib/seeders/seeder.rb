class Seeders::Seeder
  def initialize(source, riot_data)
    @source = source
    @riot_data = riot_data
  end

  def seed
    Seeders::Leagues.new(@source, @riot_data).seed
    Seeders::Events.new(@source, @riot_data).seed
    Seeders::StreamEvents.new(@source, @riot_data).seed
  end
end