class Seeders::Leagues
  def initialize(source)
    @source = source
  end

  def seed
    Riot::Data["leagues"].each do |league|
      @source.leagues << Models::League.new(riot_id: league.id, name: league.name)
    end
  end
end