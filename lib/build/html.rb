class Build::Html
  TIME_FORMAT = '%a, %d %b %Y %-l:%M %p %z'

  def build
    source = Models::Persistence.load(Build.source_path)

    build_2016(source)
    build_2015(source)
  end

  def build_2016(source)
    context = build_context.merge(
      leagues: source.leagues,
      matches: source.matches.select { |match| Time.parse(match.time).year == 2016 },
      title: '2016 Matches'
    )

    (Build.output_path + 'index.html').write(render(context))
  end

  def build_2015(source)
    context = build_context.merge(
      leagues: source.leagues,
      matches: source.matches.select { |match| Time.parse(match.time).year == 2015 },
      title: '2015 Matches'
    )

    (Build.output_path + '2015.html').write(render(context))
  end

  def render(context)
    Build::HamlContext.new(Build.build_path).render('index.haml', context)
  end

  def build_context
    {
      generated: Time.now.strftime(TIME_FORMAT),
      data_generated: Build.source_path.mtime.strftime(TIME_FORMAT)
    }
  end
end