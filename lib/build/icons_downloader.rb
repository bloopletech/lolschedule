class Build::IconsDownloader
  def initialize(source)
    @source = source
  end

  def download
    Build.icons_path.mkpath

    icons = find_icons.reject { |url, file| file.exist? }

    SyncedStdout.puts("Requesting icons...") unless icons.empty?

    Parallel.new(icons.keys).perform do |url|
      img = Magick::Image.from_blob(Client.get(url))[0]
      small = img.resize_to_fit(36, 36)
      small.write(icons[url].to_s)
    end

    nil
  end

  def find_icons
    @source.teams.map do |team|
      [Build.icons_path + "#{team.slug}.png", icon_url(team.logo)]
    end.to_h.compact.invert
  end

  def icon_url(logo)
    return nil if logo.start_with?("http://na.lolesports.com")
    return logo if logo.start_with?("https://lolstatic-a.akamaihd.net")
    "http://am-a.akamaihd.net/image/?f=#{logo}&resize=50:50"
  end
end