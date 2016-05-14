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

namespace :clean do
  task :build do
    Build::Icons.new.clean

    icons_css_path = (Build.build_path + 'css' + 'icons.css')
    icons_css_path.delete if icons_css_path.exist?

    index_html_path = (Build.output_path + 'index.html')
    index_html_path.delete if index_html_path.exist?

    icons_png_path = (Build.output_path + 'icons.png')
    icons_png_path.delete if icons_png_path.exist?
  end
end

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
