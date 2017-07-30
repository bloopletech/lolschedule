class Models::Match < Models::Model
  set_fields :riot_id, :riot_league_id, :type, :riot_team_1_id, :riot_team_2_id, :riot_player_1_id, :riot_player_2_id,
    :time, :riot_game_ids, :bracket_name

  finder name: :league, relation: :leagues, key: :riot_league_id, foreign_key: :riot_id
  finder name: :team_1, relation: :teams, key: :riot_team_1_id, foreign_key: :riot_id
  finder name: :team_2, relation: :teams, key: :riot_team_2_id, foreign_key: :riot_id
  finder name: :player_1, relation: :players, key: :riot_player_1_id, foreign_key: :riot_id
  finder name: :player_2, relation: :players, key: :riot_player_2_id, foreign_key: :riot_id

  def vods
    riot_game_ids.map { |riot_game_id| source.vods.find { |vod| vod.riot_id == riot_game_id } }.compact
  end

  def vod_urls
    vods.map { |vod| vod.url }.compact
  end

  def stream_url
    return if league.streams.empty?
    return unless league.stream_match_ids && league.stream_match_ids.include?(riot_id)

    stream = league.streams.find { |s| s[:priority] } || league.streams.first
    stream['url']
  end

  def rtime
    Time.parse(time)
  end

  def team?
    type == 'team'
  end

  def single?
    type == 'single'
  end

  def teams
    team? ? [team_1, team_2] : []
  end

  def players
    single? ? [player_1, player_2] : []
  end

  def spoiler?
    patterns = [
      /(playoffs|promotion_relegation|regionals)$/,
      /^(group_stage|bracket_stage)$/,
      /^(elimination|semifinals|finals)$/
    ]

    (rtime.year == Date.today.year) && patterns.any? { |regex| bracket_name =~ regex }
  end
end
