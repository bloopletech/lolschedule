require 'base64'
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
require 'build/json_renderer'
require 'build/json'
require 'build/stream_url'
require 'build/vod_url'
require 'riot/data'
require 'riot/data_request'
require 'riot/data_response'
require 'riot/event'
require 'riot/game'
require 'riot/league'
require 'riot/seeder'
require 'riot/stream'
require 'riot/stream_event'
require 'riot/team'
require 'riot/tournament'
require 'riot/vod'
require 'models/source'
require 'models/persistence'
require 'models/list'
require 'models/model'
require 'models/match'
require 'models/league'
require 'models/team'
require 'models/player'
require 'models/vod'
require 'seeders/leagues'
require 'seeders/stream_events'
require 'seeders/events'
require 'seeders/seeder'