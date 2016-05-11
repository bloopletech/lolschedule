module Build
  def self.root_path
    Pathname.new(__FILE__).dirname.parent
  end

  def self.data_path
    root_path + 'data'
  end

  def self.source_path
    data_path + 'source.json'
  end

  def self.build_path
    root_path + 'build'
  end

  def self.icons_path
    build_path + 'icons'
  end

  def self.output_path
    root_path + 'output'
  end
end