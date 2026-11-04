class Build::Html
  SEASONS = Build::PAST_YEARS.to_h { |year| [year, "#{year}.html"] }.merge(Build::CURRENT_YEAR => "index.html")

  def initialize
    @now = Time.now
  end

  def build
    haml_context = Build::HamlContext.new(Build.build_path)

    source = Models::Persistence.load(*Build.year_paths)

    SEASONS.each_pair do |year, file|
      Build.write_with_gz(
        path: Build.output_path + file,
        data: haml_context.render('index.haml', context(source: source, year: year))
      )
    end
  end

  def context(source:, year:)
    matches = matches_for_year(source, year)
    leagues = leagues_for_matches(source, matches)
    team_acronyms = matches.flat_map { |match| match.teams }.uniq.map { |team| team.acronym }

    {
      now: @now,
      year: year,
      leagues: leagues,
      matches: matches,
      team_acronyms: team_acronyms,
      title: "#{year} League of Legends eSports Schedule",
      generated: @now.iso8601,
      data_generated: Build.current_year_path.mtime.iso8601
    }
  end

  def matches_for_year(source, year)
    source.matches.select { |match| match.year == year }
  end

  def leagues_for_matches(source, matches)
    source.leagues.select { |league| matches.any? { |match| match.league == league } }.uniq { |league| league.slug }
  end
end