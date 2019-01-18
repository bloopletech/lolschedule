class Models::League < Models::Model
  set_fields :name, :streams, :stream_match_ids

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

  def brand_name(year)
    return name if year < 2019
    case name
    when 'EU LCS'
      'LEC'
    when 'NA LCS'
      'LCS'
    else
      name
    end
  end
end
