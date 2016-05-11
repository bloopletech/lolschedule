class Models::Persistence
  def self.load(path)
    Models::Source.from_h(JSON.parse(path.read))
  end

  def self.save(source, path)
    path.write(source.to_h.to_json)
  end
end