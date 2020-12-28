class Build::LogosDownloader
  def initialize(source)
    @source = source
  end

  def download
    Build.logos_path.mkpath

    logos = find_logos.reject { |url, files| files.all?(&:exist?) }

    SyncedStdout.puts("Requesting logos...") unless logos.empty?

    Parallel.new(logos.keys).perform do |url|
      img = Magick::Image.from_blob(Client.get(url))[0]
      small = img.resize_to_fit(36, 36)
      logos[url].each { |file| small.write(file.to_s) }
    end

    nil
  end

  def find_logos
    logos = {}
    @source.teams.each do |team|
      url = logo_url(team.logo)
      next unless url

      logos[url] ||= []
      logos[url] << Build.logos_path + "#{team.slug}.png"
    end
    logos
  end

  def logo_url(logo)
    return nil if logo.start_with?("http://na.lolesports.com")
    return logo if logo.start_with?("https://lolstatic-a.akamaihd.net")
    "https://am-a.akamaihd.net/image/?resize=60:&f=#{logo}"
  end
end