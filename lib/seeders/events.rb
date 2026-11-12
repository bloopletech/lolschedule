class Seeders::Events
  def initialize(store, riot_data)
    @store = store
    @riot_data = riot_data
  end

  def seed
    @riot_data.events.each { |event| seed_event(event) }
  end

  def seed_event(event)
    teams = seed_teams(event)

    riot_game_ids = seed_games(event)

    @store.matches << Models::Match.new({
      riot_id: event.match_id,
      riot_league_id: event.league_id,
      time: event.start_time,
      riot_game_ids: riot_game_ids,
      type: "team",
      riot_team_1_id: teams.first.acronym,
      riot_team_2_id: teams.last.acronym,
      bracket_name: event.block_name
    })
  end

  def seed_teams(event)
    event.teams.map { |riot_team| seed_team(riot_team) }
  end

  def seed_team(riot_team)
    team = @store.teams.find(riot_team.id)
    return team if team

    Models::Team.new(
      riot_id: riot_team.id,
      riot_league_id: riot_team.league_id,
      acronym: riot_team.code,
      logo: riot_team.image
    ).tap { |team| @store.teams << team }
  end

  def seed_games(event)
    if event.needs_event_detail?
      event_detail = @riot_data.event_details.find { |event_detail| event_detail.id == event.match_id }
      event_detail.games.map { |riot_game| seed_vod(riot_game) }.compact
    else
      event.games.map { |riot_game| seed_vod(riot_game) }.compact
    end
  end

  def seed_vod(game)
    vod = best_vod(game.vods)
    return nil unless vod

    @store.vods << Models::Vod.new({
      riot_id: vod.id,
      url: { provider: vod.provider, id: vod.parameter, start: vod.offset.to_s }
    })

    vod.id
  end

  def best_vod(vods)
    vod = vods.find { |vod| vod.english? && vod.youtube? }
    return vod if vod

    vod = vods.find(&:youtube?)
    return vod if vod

    vod = vods.find(&:english?)
    return vod if vod

    vods.first
  end
end
