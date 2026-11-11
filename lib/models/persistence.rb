class Models::Persistence
  def self.load(*paths)
    source = Models::Source.new
    paths.each { |path| source.from_h(JSON.parse(path.read)) }
    source
  end

  def self.save(source, path)
    path.write(source.to_h.to_json)
  end

  def self.split
    (2015..2026).each do |year|
      source = load(Build.data_path + "source.json")
      match_ids_to_remove = []
      source.matches.each { |match| match_ids_to_remove << match.riot_id if match.year != year }
      match_ids_to_remove.each { |riot_id| source.matches.delete(riot_id) }
      source.trim!
      save(source, Build.year_path(year))
    end
  end

  def self.migrate
    (2015..2026).each do |year|
      source = load(Build.year_path(year))
      source.vods.each do |vod|
        vod.url.merge!("provider" => "youtube") if vod.url
      end
      save(source, Build.year_path(year))
    end
  end
end