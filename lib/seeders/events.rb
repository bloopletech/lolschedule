class Seeders::Events
  def initialize(source)
    @source = source
  end

  def seed
    Riot::Data["events"].each do |event|
      teams = find_teams(event)

      riot_game_ids = seed_games(event)

      @source.matches << Models::Match.new({
        riot_id: event.match_id,
        riot_league_id: event.league_id,
        time: event.start_time,
        riot_game_ids: riot_game_ids,
        type: 'team',
        riot_team_1_id: teams.first.acronym,
        riot_team_2_id: teams.last.acronym
      })
    end
  end

  def find_teams(event)
    event.teams.map do |riot_team|
      riot_id = "#{event.league_id}-#{riot_team.code}"
      team = @source.teams.find(riot_id)
      next team if team

      team = Models::Team.new(
        riot_id: riot_id,
        riot_league_id: event.league_id,
        acronym: riot_team.code,
        logo: riot_team.image
      )

      @source.teams << team

      team
    end
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
