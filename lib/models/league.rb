class Models::League < Models::Model
  set_fields :riot_id, :name, :stream_url, :stream_match_ids

  def teams
    source.teams.select { |team| team.riot_league_id == riot_id }
  end

  def slug
    name.gsub(' ', '-')
  end
end
