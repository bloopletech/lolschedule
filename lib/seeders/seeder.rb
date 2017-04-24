class Seeders::Seeder
  def initialize(source)
    @source = source
  end

  def seed
    Seeders::League.new(@source).seed

    Seeders::RiotStreams.new(@source).seed

    @source.leagues.each do |league|
      Seeders::RiotLeague.new(@source, league.riot_id).seed
    end

    Seeders::RiotVideos.new(@source).seed
  end
end