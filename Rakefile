require_relative "./lib/lolschedule.rb"

namespace :data do
  desc "Download league, tournament, match, and team data"
  task :download do
    store = Models::Store.new
    riot_data = Riot::Seeder.new.seed
    Seeders::Seeder.new(store, riot_data).seed
    Models::Persistence.save(store, Build.current_year_path)
  end

  task :migrate do
    Models::Persistence.migrate
  end

  task :split do
    Models::Persistence.split
  end

  desc "Delete downloaded data"
  task :clean do
    path = Build.current_year_path
    path.delete if path.exist?
  end

  namespace :logos do
    desc "Download logos from Akamai"
    task :download do
      store = Models::Persistence.load(*Build.year_paths)
      Build::LogosDownloader.new(store).download
    end

    desc "Delete downloaded logos"
    task :clean do
      Build.logos_path.children.each { |file| file.rmtree }
    end
  end
end

task data: ["data:download", "data:logos:download"]

namespace :build do
  desc "Generate sprite sheet of downloaded logos"
  task :sprite do
    Build::SpritesBuilder.new.build
  end

  desc "Build HTML page containing schedule"
  task :html do
    Build::Html.new.build
  end

  desc "Build JSON files containing schedule"
  task :json do
    Build::Json.new.build
  end

  desc "Delete generated HTML page and logos sprite sheet"
  task :clean do
    logos_css_path = (Build.build_path + "css" + "logos.css")
    logos_css_path.delete if logos_css_path.exist?

    Build::Html::SEASONS.each_pair do |year, file|
      html_path = (Build.output_path + file)
      html_path.delete if html_path.exist?
    end

    logos_png_path = (Build.output_path + "logos.png")
    logos_png_path.delete if logos_png_path.exist?
  end
end

desc "Build complete HTML page and team logos"
task build: ["build:sprite", "build:html", "build:json"]

desc "Start an IRB console with the project and data loaded"
task :console do
  require "irb"
  ARGV.clear
  $store = Models::Persistence.load(*Build.year_paths)
  IRB.start
end

desc "Load the generated HTML page in your default browser"
task :output do
  output_path = URI.join("file:///", (Build.output_path + "index.html").realpath.to_s).to_s
  `xdg-open #{output_path}`
end

task :develop do
  exec("find . | entr rake -t build")
end

desc "Download data and logos and then build HTML page"
task default: [:data, :build]
