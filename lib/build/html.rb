class Build::Html
  SEASONS = {
    2015 => '2015.html',
    2016 => '2016.html',
    2017 => '2017.html',
    2018 => '2018.html',
    2019 => '2019.html',
    2020 => '2020.html',
    2021 => '2021.html',
    2022 => '2022.html',
    2023 => 'index.html'
  }

  def initialize
    @now = Time.now
  end

  def build
    haml_context = Build::HamlContext.new(Build.build_path)

    source = Models::Persistence.load(Build.source_path)

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
      data_generated: Build.source_path.mtime.iso8601
    }
  end

  def matches_for_year(source, year)
    source.matches.select { |match| match.rtime.year == year }
  end

  def leagues_for_matches(source, matches)
    source.leagues.select { |league| matches.any? { |match| match.league == league } }.uniq { |league| league.slug }
  end
end