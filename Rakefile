require_relative './lib/lolschedule.rb'

ROOT_PATH = Pathname.new(__FILE__).dirname
DATA_PATH = ROOT_PATH + 'data'
SOURCE_PATH = DATA_PATH + 'source.json'
INDEX_PATH = ROOT_PATH + 'build' + 'index.html'

task :data do
  source = Models::Source.new
  Seeders::Seeder.new(source).seed
  Models::SourceSaver.new(source).save(SOURCE_PATH)
end

task :download_icons do
  require 'json'
  require 'open-uri'
  require 'fileutils'
  require 'rmagick'

  FileUtils.mkdir_p('build/icons')

  data = JSON.parse(File.read(DATA_PATH))
  data.each_pair do |league_name, league|
    data['teams'].each_pair do |name, team|
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
  load 'build.rb'
end

task :deploy do
  require 'aws-sdk'

  s3 = Aws::S3::Resource.new(region: 'us-west-1')
  bucket = s3.bucket('lol-schedule')

  obj = bucket.object('index.html')
  obj.upload_file(INDEX_PATH, acl: 'public-read', cache_control: 'max-age=300', content_type: 'text/html')

  obj = bucket.object('icons.png')
  obj.upload_file('build/icons.png', acl: 'public-read', cache_control: 'max-age=3600', content_type: 'image/png')
end

task :invalidate do
  require 'aws-sdk'

  cloudfront = Aws::CloudFront::Client.new(region: 'us-west-1')
  cloudfront.create_invalidation({
    distribution_id: 'EZONQIMJRRGWP',
    invalidation_batch: {
      paths: {
        quantity: 2,
        items: ['/index.html', '/icons.png'],
      },
      caller_reference: "invalidation-#{Time.now.to_i}"
    }
  })
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
