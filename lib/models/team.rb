class Models::Team < Models::Model
  set_fields :riot_league_id, :acronym, :logo

  finder name: :league, relation: :leagues, key: :riot_league_id

  def slug
    "#{league.slug}-#{acronym}"
  end
end