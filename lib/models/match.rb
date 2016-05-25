class Models::Match < Models::Model
  set_fields :riot_id, :riot_league_id, :riot_team_1_id, :riot_team_2_id, :time, :vod_urls

  finder name: :league, relation: :leagues, key: :riot_league_id, foreign_key: :riot_id
  finder name: :team_1, relation: :teams, key: :riot_team_1_id, foreign_key: :riot_id
  finder name: :team_2, relation: :teams, key: :riot_team_2_id, foreign_key: :riot_id

  def stream_url
    return if league.streams.empty?
    return unless league.stream_match_ids && league.stream_match_ids.include?(riot_id)
    league.streams.first[:url]
  end
end
