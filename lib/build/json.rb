class Build::Json
  def build
    renderer = Build::JsonRenderer.new

    source = Models::Persistence.load(Build.source_path)

    (Build.output_path + "index.json").write(renderer.render(**context(source)))
  end

  def context(source)
    matches = source.matches.to_a
    leagues = source.leagues.to_a

    {
      leagues: leagues,
      matches: matches,
      generated: Time.now.iso8601,
      data_generated: Build.source_path.mtime.iso8601
    }
  end
end