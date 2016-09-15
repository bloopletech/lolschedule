class Build::Html
  TIME_FORMAT = '%a, %d %b %Y %-l:%M %p %z'

  def build
    haml_context = Build::HamlContext.new(Build.build_path)

    source = Models::Persistence.load(Build.source_path)

    (Build.output_path + 'index.html').write(haml_context.render('index.haml', context_2016(source)))
    (Build.output_path + '2015.html').write(haml_context.render('index.haml', context_2015(source)))
  end

  def context_2015(source)
    build_context.merge(
      leagues: source.leagues,
      matches: source.matches.select { |match| match.rtime.year == 2015 },
      title: '2015 League Schedule'
    )
  end

  def context_2016(source)
    build_context.merge(
      leagues: source.leagues,
      matches: source.matches.select { |match| match.rtime.year == 2016 },
      title: '2016 League Schedule'
    )
  end

  def build_context
    {
      generated: Time.now.strftime(TIME_FORMAT),
      data_generated: Build.source_path.mtime.strftime(TIME_FORMAT)
    }
  end
end