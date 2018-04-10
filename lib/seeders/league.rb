class Seeders::League
  def initialize(source)
    @source = source
  end

  def seed
    Riot::Data::LEAGUES.each_pair do |id, name|
      @source.leagues << Models::League.new(riot_id: id, name: name)
    end
  end
end