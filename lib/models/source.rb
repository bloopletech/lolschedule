class Models::Source
  attr_accessor :matches, :leagues, :tournaments, :teams, :players

  def self.from_h(hash)
    source = new
    hash['matches'].each { |hash| source.matches << Models::Match.new(hash) }
    hash['leagues'].each { |hash| source.leagues << Models::League.new(hash) }
    hash['tournaments'].each { |hash| source.tournaments << Models::Tournament.new(hash) }
    hash['teams'].each { |hash| source.teams << Models::Team.new(hash) }
    hash['players'].each { |hash| source.players << Models::Player.new(hash) }
    source
  end

  def initialize
    @matches = Models::List.new(self)
    @leagues = Models::List.new(self)
    @tournaments = Models::List.new(self)
    @teams = Models::List.new(self)
    @players = Models::List.new(self)
  end

  def to_h
    {
      matches: @matches.map(&:to_h),
      leagues: @leagues.map(&:to_h),
      tournaments: @tournaments.map(&:to_h),
      teams: @teams.map(&:to_h),
      players: @players.map(&:to_h)
    }
  end
end

