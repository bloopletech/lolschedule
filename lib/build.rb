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

  def self.build_path
    root_path + 'build'
  end

  def self.icons_path
    build_path + 'icons'
  end

  def self.used_icons_path
    build_path + 'used_icons'
  end

  def self.output_path
    if ENV.key?('LOLSCHEDULE_OUTPUT_DIR')
      Pathname.new(ENV['LOLSCHEDULE_OUTPUT_DIR'])
    else
      root_path + 'output'
    end
  end
end