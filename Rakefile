require_relative './lib/lolschedule.rb'

ROOT_PATH = Pathname.new(__FILE__).dirname
DATA_PATH = ROOT_PATH + 'data'
SOURCE_PATH = DATA_PATH + 'source.json'
BUILD_PATH = ROOT_PATH + 'build'
ICONS_PATH = BUILD_PATH + 'icons'
INDEX_PATH = BUILD_PATH + 'index.html'

task :data do
  source = Models::Source.new
  Seeders::Seeder.new(source).seed
  Models::Persistence.save(source, SOURCE_PATH)
end

task :download_icons do
  source = Models::Persistence.load(SOURCE_PATH)
  Build::Icons.new(ICONS_PATH).download(source)
end

task :clean_icons do
  Build::Icons.new(ICONS_PATH).clean
end

task :build_sprite do
  Build::Icons.new(ICONS_PATH).build_sprites
end

task :build do
  Build::Build.new(BUILD_PATH, SOURCE_PATH).build
end

task :deploy do
  Build::Aws.new.deploy(INDEX_PATH, ICONS_PATH)
end

task :invalidate do
  Build::Aws.new.invalidate
end

task :console do
  require 'irb'
  ARGV.clear
  IRB.start
end

task :develop do
  exec('find . | entr rake -t build')
end

task default: [:data, :download_icons, :build_sprite, :build, :deploy]
