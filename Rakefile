require_relative './lib/lolschedule.rb'

desc 'Download league, tournament, match, and team data'
task :data do
  source = Models::Persistence.load(Build.archived_source_path)
  Seeders::Seeder.new(source).seed
  Models::Persistence.save(source, Build.source_path)
end

namespace :build do
  namespace :logos do
    desc 'Download logos from Akamai'
    task :download do
      source = Models::Persistence.load(Build.source_path)
      Build::LogosDownloader.new(source).download
    end

    desc 'Delete downloaded logos'
    task :clean do
      Build.logos_path.children.each { |file| file.rmtree }
    end

    desc 'Generate sprite sheet of downloaded logos'
    task :sprite do
      Build::SpritesBuilder.new.build
    end
  end

  desc 'Build HTML page containing schedule'
  task :html do
    Build::Html.new.build
  end

  desc 'Build JSON files containing schedule'
  task :json do
    Build::Json.new.build
  end
end

desc 'Build complete HTML page and team logos'
task build: ['build:logos:download', 'build:logos:sprite', 'build:html', 'build:json']

namespace :clean do
  desc 'Delete generated HTML page and logos sprite sheet'
  task :build do
    Build.logos_path.children.each { |file| file.rmtree }

    logos_css_path = (Build.build_path + 'css' + 'logos.css')
    logos_css_path.delete if logos_css_path.exist?

    Build::Html::SEASONS.each_pair do |year, file|
      html_path = (Build.output_path + file)
      html_path.delete if html_path.exist?
    end

    logos_png_path = (Build.output_path + 'logos.png')
    logos_png_path.delete if logos_png_path.exist?
  end
end

desc 'Start an IRB console with the project and data loaded'
task :console do
  require 'irb'
  ARGV.clear
  $source = Models::Persistence.load(Build.source_path)
  IRB.start
end

desc 'Load the generated HTML page in your default browser'
task :output do
  output_path = URI.join('file:///', (Build.output_path + 'index.html').realpath.to_s).to_s
  `xdg-open #{output_path}`
end

task :develop do
  exec('find . | entr rake -t build')
end

desc 'Download data and then build HTML page and logos'
task default: [:data, :build]
