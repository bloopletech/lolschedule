class Build::Json
  def initialize
    @now = Time.now
  end

  def build
    output = Build::JsonRenderer.new(@now).render(**context)

    Build.write_with_gz(path: Build.output_path + "data.json", data: output)
  end

  def context
    store = Models::Persistence.load(*Build.year_paths)

    matches = store.matches.to_a
    leagues = store.leagues.to_a

    {
      leagues: leagues,
      matches: matches,
      generated: @now.iso8601,
      data_generated: Build.current_year_path.mtime.iso8601
    }
  end
end