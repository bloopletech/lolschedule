require_relative './lib/lolschedule.rb'

desc 'Download league, tournament, match, and team data'
task :data do
  source = Models::Source.new
  Seeders::Seeder.new(source).seed
  Models::Persistence.save(source, Build.source_path)
end

namespace :build do
  namespace :icons do
    desc 'Download icons from Akamai'
    task :download do
      Build::Icons.new.download
    end

    desc 'Delete downloaded icons'
    task :clean do
      Build::Icons.new.clean
    end

    desc 'Generate sprite sheet of downloaded icons'
    task :sprite do
      Build::Icons.new.build_sprites
    end
  end

  desc 'Build HTML page containing schedule'
  task :html do
    Build::Html.new.build
  end
end

desc 'Build complete HTML page and team icons'
task build: ['build:icons:download', 'build:icons:sprite', 'build:html']

namespace :clean do
  desc 'Delete generated HTML page and icons sprite sheet'
  task :build do
    Build::Icons.new.clean

    icons_css_path = (Build.build_path + 'css' + 'icons.css')
    icons_css_path.delete if icons_css_path.exist?

    Build::Html::YEARS_FILES.each_pair do |year, file|
      html_path = (Build.output_path + file)
      html_path.delete if html_path.exist?
    end

    icons_png_path = (Build.output_path + 'icons.png')
    icons_png_path.delete if icons_png_path.exist?
  end
end

desc 'Push generated HTML page and icons sprite sheet to CloudFront'
task :deploy do
  Build::Aws.new.deploy
end

desc 'Create an invalidation in CloudFront'
task :invalidate do
  Build::Aws.new.invalidate
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

desc 'Download data, build HTML page and icons, and deploy output to CloudFront'
task default: [:data, :build, :deploy]
