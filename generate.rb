require 'haml'
require 'json'

template = File.read('index.haml')
data = JSON.parse(File.read('data.json'))
haml_engine = Haml::Engine.new(template)
output = haml_engine.render(Object.new, { data: data })
File.open('index.html', 'w') { |f| f << output }