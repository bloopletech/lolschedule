class Build::Icons
  def initialize(icons_path)
    @icons_path = icons_path
  end

  def download(source)
    @icons_path.mkdir_p

    source.teams.each do |team|
      file = @icons_path + "#{team.slug}.png"

      unless file.exist?
        body = URI.parse("http://am-a.akamaihd.net/image/?f=#{team.logo}&resize=50:50").read
        img = Magick::Image.from_blob(body)[0]
        small = img.resize_to_fit(26, 26)
        small.write(file.to_s)
      end
    end
  end

  def clean
    @icons_path.children.each { |file| file.rmtree }
  end

  def build_sprites
    SpriteFactory.run!(@icons_path.to_s, margin: 1, selector: '.')
  end
end