require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

$:.unshift(File.dirname(__FILE__))

require 'fileutils'
require 'forwardable'
require 'pathname'
require 'open-uri'
require 'json'
require 'time'
require 'set'
require 'cgi'

module Build
end

module Models
end

module Seeders
end

module Riot
end

require 'build/haml_context'
require 'build/icons'
require 'build/html'
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