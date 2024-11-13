class Models::Source
  attr_accessor :matches, :vods, :leagues, :teams, :players

  def self.from_h(hash)
    source = new
    source.from_h(hash)
    source
  end

  def initialize
    @matches = Models::List.new(self)
    @vods = Models::List.new(self)
    @leagues = Models::List.new(self)
    @teams = Models::List.new(self)
    @players = Models::List.new(self)
  end

  def from_h(hash)
    hash['matches'].each { |hash| @matches << Models::Match.new(hash) }
    hash['vods'].each { |hash| @vods << Models::Vod.new(hash) }
    hash['leagues'].each { |hash| @leagues << Models::League.new(hash) }
    hash['teams'].each { |hash| @teams << Models::Team.new(hash) }
    hash['players'].each { |hash| @players << Models::Player.new(hash) }
  end

  def to_h
    {
      matches: @matches.map(&:to_h),
      vods: @vods.map(&:to_h),
      leagues: @leagues.map(&:to_h),
      teams: @teams.map(&:to_h),
      players: @players.map(&:to_h)
    }
  end

  def trim!
    used_league_ids = @matches.map { |match| match.riot_league_id }
    league_ids_to_remove = @leagues.map(&:riot_id) - used_league_ids
    league_ids_to_remove.each { |league_id| @leagues.delete(league_id) }

    used_team_ids = @matches.map { |match| [match.combined_team_1_id, match.combined_team_2_id] }.flatten.compact
    team_ids_to_remove = @teams.map(&:riot_id) - used_team_ids
    team_ids_to_remove.each { |team_id| @teams.delete(team_id) }

    used_player_ids = @matches.map { |match| [match.combined_player_1_id, match.combined_player_2_id] }.flatten.compact
    player_ids_to_remove = @players.map(&:riot_id) - used_player_ids
    player_ids_to_remove.each { |player_id| @players.delete(player_id) }

    used_vod_ids = @matches.map { |match| match.riot_game_ids }.flatten
    vod_ids_to_remove = @vods.map(&:riot_id) - used_vod_ids
    vod_ids_to_remove.each { |vod_id| @vods.delete(vod_id) }
  end
end

