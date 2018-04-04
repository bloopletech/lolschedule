class Models::Player < Models::Model
  set_fields :riot_league_id, :name

  finder name: :league, relation: :leagues, key: :riot_league_id

  def slug
    "#{league.slug}-#{name}"
  end
end