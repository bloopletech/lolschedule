class Models::League < Models::Model
  set_fields :riot_id, :name, :stream_url, :stream_match_ids

  def slug
    name.gsub(' ', '-')
  end
end
