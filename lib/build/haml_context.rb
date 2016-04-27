class Build::HamlContext
  ENGINE_OPTIONS = { remove_whitespace: true, escape_html: true, ugly: true }

  def initialize(build_path)
    @build_path = build_path
  end

  def render(template, locals = {})
    haml_engine = Haml::Engine.new(include(template), ENGINE_OPTIONS)
    haml_engine.render(self, locals)
  end

  def partial(name, locals = {})
    render("_#{name}.haml", locals)
  end

  def include(path)
    (@build_path + path).read
  end
end