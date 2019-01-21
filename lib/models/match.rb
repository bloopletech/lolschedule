class Models::Match < Models::Model
  set_fields :riot_league_id, :type, :riot_team_1_id, :riot_team_2_id, :riot_player_1_id, :riot_player_2_id, :time,
    :riot_game_ids, :bracket_name

  finder name: :league, relation: :leagues, key: :riot_league_id
  finder name: :team_1, relation: :teams, key: :combined_team_1_id
  finder name: :team_2, relation: :teams, key: :combined_team_2_id
  finder name: :player_1, relation: :players, key: :combined_player_1_id
  finder name: :player_2, relation: :players, key: :combined_player_2_id

  def combined_team_1_id
    "#{riot_league_id}-#{riot_team_1_id}"
  end

  def combined_team_2_id
    "#{riot_league_id}-#{riot_team_2_id}"
  end

  def combined_player_1_id
    "#{riot_league_id}-#{riot_player_1_id}"
  end

  def combined_player_2_id
    "#{riot_league_id}-#{riot_player_2_id}"
  end

  def vods
    source.vods.find_all(riot_game_ids)
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
    @rtime ||= parse_time(time)
  end

  def parse_time(time)
    Time.xmlschema("#{time[0..18]}+00:00")
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
      /^(group_stage|bracket_stage|playoffs_bracket)$/,
      /^(elimination|semifinals|finals)$/
    ]

    (rtime.year == Date.today.year) && patterns.any? { |regex| bracket_name =~ regex }
  end
end
