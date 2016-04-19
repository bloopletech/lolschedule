class Models::SourceLoader
  def initialize
  end
  
  def load(path)
    hash = JSON.parse(File.read(path))
    Models::Source.from_h(hash)
  end
end