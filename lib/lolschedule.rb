require 'cgi'
require 'fileutils'
require 'forwardable'
require 'json'
require 'open-uri'
require 'pathname'
require 'set'
require 'time'
require 'singleton'

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

$:.unshift(File.dirname(__FILE__))

Dotenv.load

module Models
end

module Seeders
end

module Riot
end

require 'error_reporting'
require 'build'
require 'build/haml_context'
require 'build/icons'
require 'build/serializers/league'
require 'build/serializers/leagues'
require 'build/serializers/match'
require 'build/serializers/matches'
require 'build/data'
require 'build/html'
require 'build/aws'
require 'riot/api_client'
require 'riot/league'
require 'riot/streams'
require 'riot/tournament'
require 'models/source'
require 'models/persistence'
require 'models/list'
require 'models/model'
require 'models/match'
require 'models/league'
require 'models/team'
require 'seeders/league'
require 'seeders/riot_league'
require 'seeders/riot_streams'
require 'seeders/riot_tournament'
require 'seeders/seeder'