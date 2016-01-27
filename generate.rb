require 'haml'
require 'json'

TIME_FORMAT = '%a, %d %b %Y %-l:%M %p %z'

template = File.read('index.haml')
data = JSON.parse(File.read('data.json'))

haml_engine = Haml::Engine.new(template, { remove_whitespace: true, escape_html: true, ugly: true })
output = haml_engine.render(Object.new, {
  data: data,
  generated: Time.now.strftime(TIME_FORMAT),
  data_generated: File.mtime('data.json').strftime(TIME_FORMAT)
})

File.open('index.html', 'w') { |f| f << output }