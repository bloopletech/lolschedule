class Models::Persistence
  def self.load(*paths)
    source = Models::Source.new
    paths.each { |path| source.from_h(JSON.parse(path.read)) }
    source
  end

  def self.save(source, path)
    path.write(source.to_h.to_json)
  end
end