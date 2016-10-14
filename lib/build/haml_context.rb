class Build::HamlContext
  ENGINE_OPTIONS = { remove_whitespace: true, escape_html: true, ugly: true }

  def initialize(build_path)
    @build_path = build_path
    @haml_engine_cache = {}
  end

  def render(template, locals = {})
    haml_engine(template).render(self, locals)
  end

  def partial(name, locals = {})
    render("_#{name}.haml", locals)
  end

  def include(path)
    (@build_path + path).read
  end

  def surprise_link(url)
    Build::SurpriseLinker.new(url).link
  end

  def haml_engine(path)
    @haml_engine_cache[path] = Haml::Engine.new(include(path), ENGINE_OPTIONS) unless @haml_engine_cache.key?(path)
    @haml_engine_cache[path]
  end
end