class Seeders::Seeder
  def initialize(source)
    @source = source
  end

  def seed
    Riot::Seeder.new.seed

    Seeders::Leagues.new(@source).seed

    Seeders::Events.new(@source).seed

    Seeders::StreamEvents.new(@source).seed
  end
end