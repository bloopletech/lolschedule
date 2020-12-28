class Models::Tournament < Models::Model
  set_fields :riot_league_id, :name, :slug, :start_time, :end_time

  finder name: :league, relation: :leagues, key: :riot_league_id
end
