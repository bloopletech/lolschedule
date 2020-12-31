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
    return name.dup if year < 2019
    case name
    when 'EU LCS'
      'LEC'
    when 'NA LCS'
      'LCS'
    when 'All-Star Event'
      'All-Star'
    else
      name.dup
    end
  end

  def brand_name_short(year)
    case name
    when 'LCS Academy'
      'LCSA'
    when 'European Masters'
      'EU Mas'
    else
      brand_name(year)
    end
  end

  def brand_name_full(year)
    result = brand_name(year)
    result << " (#{brand_name_short(year)})" if result != brand_name_short(year)
    result
  end
end
