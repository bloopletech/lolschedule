class Build::Html
  TIME_FORMAT = '%a, %d %b %Y %-l:%M %p %z'

  def build
    haml_context = Build::HamlContext.new(Build.build_path)

    source = Models::Persistence.load(Build.source_path)

    (Build.output_path + 'index.html').write(haml_context.render('index.haml', context(source, 2016)))
    (Build.output_path + '2015.html').write(haml_context.render('index.haml', context(source, 2015)))
  end

  def context(source, year)
    {
      leagues: source.leagues,
      matches: source.matches.select { |match| match.rtime.year == year },
      title: "#{year} League Schedule",
      generated: Time.now.strftime(TIME_FORMAT),
      data_generated: Build.source_path.mtime.strftime(TIME_FORMAT)
    }
  end
end