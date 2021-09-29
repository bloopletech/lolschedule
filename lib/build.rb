module Build
  def self.root_path
    Pathname.new(__FILE__).dirname.parent
  end

  def self.data_path
    if ENV.key?('LOLSCHEDULE_DATA_DIR')
      Pathname.new(ENV['LOLSCHEDULE_DATA_DIR'])
    else
      root_path + 'data'
    end
  end

  def self.source_path
    data_path + 'source.json'
  end

  def self.archived_source_path
    data_path + 'archived.json'
  end

  def self.build_path
    root_path + 'build'
  end

  def self.logos_path
    build_path + 'logos'
  end

  def self.used_logos_path
    build_path + 'used_logos'
  end

  def self.output_path
    if ENV.key?('LOLSCHEDULE_OUTPUT_DIR')
      Pathname.new(ENV['LOLSCHEDULE_OUTPUT_DIR'])
    else
      root_path + 'output'
    end
  end

  def self.grouped_logos
    group = {}

    logos_path.children.each do |file|
      hash = Magick::Image.read(file.to_s).first.signature
      group[hash] ||= []
      group[hash] << file
    end

    group.values
  end

  def self.write_with_gz(path:, data:)
    path.write(data)
    Pathname.new("#{path.to_s}.gz").write(Zlib.gzip(data, level: Zlib::BEST_COMPRESSION))
  end
end