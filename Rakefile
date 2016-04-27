require_relative './lib/lolschedule.rb'

task :data do
  source = Models::Source.new
  Seeders::Seeder.new(source).seed
  Models::Persistence.save(source, Build.source_path)
end

namespace :build do
  namespace :icons do
    task :download do
      Build::Icons.new.download
    end

    task :clean do
      Build::Icons.new.clean
    end

    task :sprite do
      Build::Icons.new.build_sprites
    end
  end

  task :html do
    Build::Html.new.build
  end
end

task build: ['build:icons:download', 'build:icons:sprite', 'build:html']

task :deploy do
  Build::Aws.new.deploy
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

task default: [:data, :build, :deploy]
