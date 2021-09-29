class Build::Json
  def build
    output = Build::JsonRenderer.new.render(**context)

    (Build.output_path + "index.json").write(output)
    (Build.output_path + "index.json.gz").write(Zlib.gzip(output, level: Zlib::BEST_COMPRESSION))
  end

  def context
    source = Models::Persistence.load(Build.source_path)

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