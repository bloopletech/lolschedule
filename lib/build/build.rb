class Build::Build
  TIME_FORMAT = '%a, %d %b %Y %-l:%M %p %z'

  def initialize(build_path, source_path)
    @build_path = build_path
    @source_path = source_path
  end

  def build
    (@build_path + 'index.html').write(render)
  end

  def render
    Build::HamlContext.new(@build_path).render('index.haml', context)
  end

  def context
    source = Models::Persistence.load(@source_path)

    {
      source: source,
      generated: Time.now.strftime(TIME_FORMAT),
      data_generated: @source_path.mtime.strftime(TIME_FORMAT)
    }
  end
end