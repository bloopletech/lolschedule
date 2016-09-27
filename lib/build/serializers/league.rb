class Build::Serializers::League
  def initialize(league)
    @league = league
  end

  def serialize
    @league.streams.map do |stream|
      {
        league_name: @league.name,
        id: stream['id'],
        url: stream['url']
      }
    end
  end
end