class Models::SourceSaver
  def initialize(source)
    @source = source
  end
  
  def save(path)
    File.open(path, "w") do |f|
      f << @source.to_h.to_json
    end
  end
end