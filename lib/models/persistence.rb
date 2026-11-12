class Models::Persistence
  def self.load(*paths)
    store = Models::Store.new
    paths.each { |path| store.from_h(JSON.parse(path.read)) }
    store
  end

  def self.save(store, path)
    path.write(store.to_h.to_json)
  end

  def self.split
    (2015..2026).each do |year|
      store = load(Build.data_path + "store.json")
      match_ids_to_remove = []
      store.matches.each { |match| match_ids_to_remove << match.riot_id if match.year != year }
      match_ids_to_remove.each { |riot_id| store.matches.delete(riot_id) }
      store.trim!
      save(store, Build.year_path(year))
    end
  end

  def self.migrate
    (2015..2026).each do |year|
      store = load(Build.year_path(year))
      store.vods.each do |vod|
        vod.url.merge!("provider" => "youtube") if vod.url
      end
      save(store, Build.year_path(year))
    end
  end
end