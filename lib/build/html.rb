class Build::Html
  TIME_FORMAT = '%a, %d %b %Y %-l:%M %p %z'

  def build
    (Build.output_path + 'index.html').write(render)
  end

  def render
    Build::HamlContext.new(Build.build_path).render('index.haml', context)
  end

  def context
    source = Models::Persistence.load(Build.source_path)

    {
      source: source,
      generated: Time.now.strftime(TIME_FORMAT),
      data_generated: Build.source_path.mtime.strftime(TIME_FORMAT)
    }
  end
end