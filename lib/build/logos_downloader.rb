class Build::LogosDownloader
  def initialize(source)
    @source = source
  end

  def download
    Build.logos_path.mkpath

    logos = find_logos.reject { |url, file| file.exist? }

    SyncedStdout.puts("Requesting logos...") unless logos.empty?

    Parallel.new(logos.keys).perform do |url|
      img = Magick::Image.from_blob(Client.get(url))[0]
      small = img.resize_to_fit(36, 36)
      small.write(logos[url].to_s)
    end

    nil
  end

  def find_logos
    @source.teams.map do |team|
      [Build.logos_path + "#{team.slug}.png", logo_url(team.logo)]
    end.to_h.compact.invert
  end

  def logo_url(logo)
    return nil if logo.start_with?("http://na.lolesports.com")
    return logo if logo.start_with?("https://lolstatic-a.akamaihd.net")
    "http://am-a.akamaihd.net/image/?f=#{logo}&resize=50:50"
  end
end