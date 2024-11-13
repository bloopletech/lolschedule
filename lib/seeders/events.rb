class Seeders::Events
  def initialize(source)
    @source = source
  end

  def seed
    Riot::Data["events"].each { |event| seed_event(event) }
  end

  def seed_event(event)
    return unless event.year >= 2022

    teams = seed_teams(event)

    riot_game_ids = seed_games(event)

    @source.matches << Models::Match.new({
      riot_id: event.match_id,
      riot_league_id: event.league_id,
      time: event.start_time,
      riot_game_ids: riot_game_ids,
      type: 'team',
      riot_team_1_id: teams.first.acronym,
      riot_team_2_id: teams.last.acronym,
      bracket_name: event.block_name
    })
  end

  def seed_teams(event)
    event.teams.map { |riot_team| seed_team(riot_team) }
  end

  def seed_team(riot_team)
    team = @source.teams.find(riot_team.id)
    return team if team

    Models::Team.new(
      riot_id: riot_team.id,
      riot_league_id: riot_team.league_id,
      acronym: riot_team.code,
      logo: riot_team.image
    ).tap { |team| @source.teams << team }
  end

  def seed_games(event)
    event.games.map { |riot_game| seed_vods(riot_game) }.flatten
  end

  def seed_vods(game)
    game.vods.map do |riot_vod|
      @source.vods << Models::Vod.new({
        riot_id: riot_vod.id,
        url: { id: riot_vod.parameter, start: "0" }
      })

      riot_vod.id
    end
  end
end
