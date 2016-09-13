class Models::Match < Models::Model
  CURRENT_YEAR = Time.parse("2016-01-01")

  set_fields :riot_id, :riot_league_id, :riot_team_1_id, :riot_team_2_id, :time, :vod_urls

  finder name: :league, relation: :leagues, key: :riot_league_id, foreign_key: :riot_id
  finder name: :team_1, relation: :teams, key: :riot_team_1_id, foreign_key: :riot_id
  finder name: :team_2, relation: :teams, key: :riot_team_2_id, foreign_key: :riot_id

  def stream_url
    return if league.streams.empty?
    return unless league.stream_match_ids && league.stream_match_ids.include?(riot_id)

    stream = league.streams.find { |s| s[:priority] } || league.streams.first
    stream['url']
  end

  def current?
    Time.parse(time) >= CURRENT_YEAR
  end
end
