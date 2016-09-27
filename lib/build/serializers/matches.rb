class Build::Serializers::Matches
  def initialize(matches)
    @matches = matches
  end

  def serialize
    @matches.map { |match| Build::Serializers::Match.new(match).serialize }
  end
end