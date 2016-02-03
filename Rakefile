DATA_PATH = 'build/data.json'
INDEX_PATH = 'build/index.html'

task :data do
  load 'get_data.rb'
end

task :download_icons do
  require 'json'
  require 'open-uri'
  require 'fileutils'
  require 'rmagick'

  FileUtils.mkdir_p('build/icons')

  data = JSON.parse(File.read(DATA_PATH))
  data.each_pair do |league_name, league|
    league['teams'].each_pair do |name, team|
      filename = "build/icons/#{league_name.gsub(' ', '-')}-#{name}.png"

      unless File.exist?(filename)
        body = URI.parse("http://am-a.akamaihd.net/image/?f=#{team['logo']}&resize=50:50").read
        img = Magick::Image.from_blob(body)[0]
        small = img.resize_to_fit(26, 26)
        small.write(filename)
      end
    end
  end
end

task :clean_icons do
  require 'fileutils'
  FileUtils.rm_r(Dir.glob('build/icons/*'))
end

task :build_sprite do
  require 'sprite_factory'

  SpriteFactory.run!('build/icons', margin: 1, selector: '.')
end

task :build do
  require 'haml'
  require 'json'

  TIME_FORMAT = '%a, %d %b %Y %-l:%M %p %z'

  template = File.read('index.haml')
  data = JSON.parse(File.read(DATA_PATH))

  context = {
    data: data,
    generated: Time.now.strftime(TIME_FORMAT),
    data_generated: File.mtime(DATA_PATH).strftime(TIME_FORMAT)
  }

  output = Dir.chdir('build') do
    haml_engine = Haml::Engine.new(template, { remove_whitespace: true, escape_html: true, ugly: true })
    haml_engine.render(Object.new, context)
  end

  File.open(INDEX_PATH, 'w') { |f| f << output }
end

task :deploy do
  require 'aws-sdk'

  s3 = Aws::S3::Resource.new(region: 'us-west-1')
  bucket = s3.bucket('lol-schedule')

  obj = bucket.object('index.html')
  obj.upload_file(INDEX_PATH, acl: 'public-read', cache_control: 'max-age=300', content_type: 'text/html')

  obj = bucket.object('icons.png')
  obj.upload_file('build/icons.png', acl: 'public-read', cache_control: 'max-age=300', content_type: 'image/png')
end

task :console do
  require 'json'
  require 'awesome_print'

  require 'irb'
  ARGV.clear
  IRB.start
end

task :develop do
  exec('find . | entr rake -t build')
end

task default: [:data, :download_icons, :build_sprite, :build, :deploy]
