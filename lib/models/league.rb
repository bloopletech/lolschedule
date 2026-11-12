class Models::League < Models::Model
  set_fields :name, :streams, :stream_match_ids

  def initialize(attributes = {})
    @streams = []
    super(attributes)
  end

  def teams
    store.teams.select { |team| team.riot_league_id == riot_id }
  end

  def slug
    name.gsub(" ", "-")
  end

  def brand_name(year)
    return name.dup if year < 2019
    case name
    when "EU LCS"
      "LEC"
    when "NA LCS"
      "LCS"
    when "All-Star Event"
      "All-Star"
    when "EMEA Masters"
      year <= 2022 ? "European Masters" : name.dup
    when "LCO"
      year <= 2020 ? "OPL" : name.dup
    else
      name.dup
    end
  end

  def brand_name_short(year)
    case name
    when "LCS Academy"
      "LCSA"
    when "European Masters"
      "EU Mas"
    when "LCS Challengers"
      "LCS Chl"
    when "LCK Challengers"
      "LCK Chl"
    when "CBLOL Academy"
      "CBLOLA"
    when "EMEA Masters"
      year <= 2022 ? "EU Mas" : "EMEA"
    when "LJL Academy"
      "LJLA"
    when "LTA North"
      "LTA Nth"
    when "LTA South"
      "LTA Sth"
    when "LTA Cross-Conference"
      "LTA CC"
    when "La Ligue Française"
      "🇫🇷"
    when "Prime League"
      "🇩🇪"
    when "Hellenic Legends League"
      "🇬🇷"
    when "Hitpoint Masters"
      "🇨🇿 🇸🇰"
    when "Road of Legends"
      "🇳🇱"
    when "LoL Italian Tournament"
      "🇮🇹"
    when "Liga Portuguesa"
      "🇵🇹"
    when "Esports Balkan League"
      "🇷🇸"
    when "Circuito Desafiante"
      "🇧🇷"
    when "Arabian League"
      "Arab"
    when "Rift Legends"
      "🇵🇱"
    when "First Stand"
      "FST"
    when "LCS Promotion"
      "LCS Pro"
    when "CBLOL Promotion"
      "CBLOLP"
    when "Asian Games"
      "Asiad"
    when "KeSPA Cup"
      "KeSPA"
    when "Esports World Cup"
      "EWC"
    when "Americas Cup"
      "Ame Cup"
    when "LCP P&R"
      "LCP Pro"
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
