class Build::HamlContext
  def initialize(views_path)
    @views_path = views_path
    @haml_engine_cache = {}
  end

  def render(template, locals = {})
    haml_engine(template).render(self, locals)
  end

  def partial(name, locals = {})
    render("_#{name}.haml", locals)
  end

  def include(path)
    (@views_path + path).read
  end

  def haml_engine(path)
    unless @haml_engine_cache.key?(path)
      @haml_engine_cache[path] = Hamlit::Template.new(filename: path) { include(path) }
    end
    @haml_engine_cache[path]
  end
end