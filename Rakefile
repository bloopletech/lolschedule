DATA_PATH = 'data.json'
INDEX_PATH = 'index.html'

task :data do
  load 'get_data.rb'
end

task :build do
  require 'haml'
  require 'json'

  TIME_FORMAT = '%a, %d %b %Y %-l:%M %p %z'

  template = File.read('index.haml')
  data = JSON.parse(File.read(DATA_PATH))

  haml_engine = Haml::Engine.new(template, { remove_whitespace: true, escape_html: true, ugly: true })
  output = haml_engine.render(Object.new, {
    data: data,
    generated: Time.now.strftime(TIME_FORMAT),
    data_generated: File.mtime(DATA_PATH).strftime(TIME_FORMAT)
  })

  File.open(INDEX_PATH, 'w') { |f| f << output }
end

task :deploy do
  require 'aws-sdk'

  s3 = Aws::S3::Resource.new(region: 'us-west-1')
  obj = s3.bucket('lol-schedule').object(INDEX_PATH)
  obj.upload_file(INDEX_PATH, acl: 'public-read', cache_control: 'max-age=3600')
end

task :console do
  require 'json'
  require 'awesome_print'

  require 'irb'
  ARGV.clear
  IRB.start
end

task default: [:data, :build, :deploy]
