require 'cgi'
require 'forwardable'
require 'json'
require 'pathname'
require 'time'

require 'rubygems'
require 'bundler/setup'
ENV['LOLSCHEDULE_ENV'] ||= 'development'
Bundler.require(:default, ENV['LOLSCHEDULE_ENV'])

$:.unshift(File.dirname(__FILE__))

Dotenv.load

module Models
end

module Seeders
end

module Riot
end

require 'error_reporting'
require 'synced_stdout'
require 'client'
require 'parallel'
require 'build'
require 'build/haml_context'
require 'build/logos_downloader'
require 'build/sprites_builder'
require 'build/html'
require 'build/vod_url'
require 'riot/data'
require 'riot/league'
require 'riot/streams'
require 'riot/tournament'
require 'riot/videos'
require 'models/source'
require 'models/persistence'
require 'models/list'
require 'models/model'
require 'models/match'
require 'models/vod'
require 'models/league'
require 'models/team'
require 'models/player'
require 'seeders/youtube_link_parser'
require 'seeders/league'
require 'seeders/riot_league'
require 'seeders/riot_streams'
require 'seeders/riot_tournament'
require 'seeders/riot_videos'
require 'seeders/seeder'