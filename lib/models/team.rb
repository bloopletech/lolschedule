class Models::Team < Models::Model
  set_fields :riot_id, :riot_league_id, :acronym, :logo

  finder name: :league, relation: :leagues, key: :riot_league_id, foreign_key: :riot_id

  def slug
    "#{league.slug}-#{acronym}"
  end
end