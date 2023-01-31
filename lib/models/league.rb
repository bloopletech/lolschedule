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
    when 'EMEA Masters'
      year <= 2022 ? 'European Masters' : name.dup
    when 'LCO'
      year <= 2020 ? 'OPL' : name.dup
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
    when 'LCS Challengers'
      'LCS Chl'
    when 'LCK Challengers'
      'LCK Chl'
    when 'CBLOL Academy'
      'CBLOLA'
    when 'EMEA Masters'
      year <= 2022 ? 'EU Mas' : 'EMEA'
    when 'LJL Academy'
      'LJLA'
    else
      brand_name(year)
    end
  end

  def brand_name_full(year)
    result = brand_name(year)
    result << " (#{brand_name_short(year)})" if result != brand_name_short(year)
    result
  end

  def international?
    ["worlds", "msi", "all-star", "all-star-event"].include?(slug.downcase)
  end
end
