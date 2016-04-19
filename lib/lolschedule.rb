$:.unshift(File.dirname(__FILE__))

require 'forwardable'
require 'pathname'
require 'open-uri'
require 'json'
require 'time'
require 'set'
require 'cgi'

module Riot
end

module Models
end

module Seeders
end

module Riot
end

require 'riot/api_client'
require 'riot/league'
require 'riot/tournament'
require 'models/source'
require 'models/source_loader'
require 'models/source_saver'
require 'models/list'
require 'models/model'
require 'models/match'
require 'models/league'
require 'models/team'
require 'seeders/league'
require 'seeders/riot_league'
require 'seeders/riot_tournament'
require 'seeders/seeder'