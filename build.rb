require 'haml'
require 'json'

TIME_FORMAT = '%a, %d %b %Y %-l:%M %p %z'

class HamlContext
  ENGINE_OPTIONS = { remove_whitespace: true, escape_html: true, ugly: true }

  def render(template, locals = {})
    haml_engine = Haml::Engine.new(File.read(template), ENGINE_OPTIONS)
    haml_engine.render(self, locals)
  end

  def partial(name, locals = {})
    render("_#{name}.haml", locals)
  end

  def include(path)
    File.read(path)
  end
end

data = JSON.parse(File.read(DATA_PATH))

context = {
  data: data,
  generated: Time.now.strftime(TIME_FORMAT),
  data_generated: File.mtime(DATA_PATH).strftime(TIME_FORMAT)
}

output = Dir.chdir('build') { HamlContext.new.render('index.haml', context) }

File.open(INDEX_PATH, 'w') { |f| f << output }