class Models::League < Models::Model
  set_fields :riot_id, :name, :streams, :stream_match_ids

  def initialize(attributes = {})
    @streams = []
    super(attributes)
  end

  def teams
    source.teams.select { |team| team.riot_league_id == riot_id }
  end

  def slug
    name.gsub(' ', '-')
  end
end
