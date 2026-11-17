module Build
  YEARS = (2015..2026).to_a
  CURRENT_YEAR = YEARS.last
  PAST_YEARS = YEARS[0..-2]

  def self.root_path
    Pathname.new(__FILE__).dirname.parent
  end

  def self.archived_path
    root_path + "archived"
  end

  def self.data_path
    if ENV.key?("LOLSCHEDULE_DATA_DIR")
      Pathname.new(ENV["LOLSCHEDULE_DATA_DIR"])
    else
      root_path + "data"
    end
  end

  def self.year_path(year)
    if year == CURRENT_YEAR
      data_path + "#{year}.json"
    else
      archived_path + "#{year}.json"
    end
  end

  def self.current_year_path
    year_path(CURRENT_YEAR)
  end

  def self.year_paths
    YEARS.map { |year| year_path(year) }
  end

  def self.logos_path
    data_path + "logos"
  end

  def self.used_logos_path
    data_path + "used_logos"
  end

  def self.views_path
    root_path + "views"
  end

  def self.output_path
    if ENV.key?("LOLSCHEDULE_OUTPUT_DIR")
      Pathname.new(ENV["LOLSCHEDULE_OUTPUT_DIR"])
    else
      root_path + "output"
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