class Build::Serializers::Leagues
  def initialize(leagues)
    @leagues = leagues
  end

  def serialize
    @leagues.map { |league| Build::Serializers::League.new(league).serialize }
  end
end