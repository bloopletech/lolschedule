class Build::Icons
  def download
    source = Models::Persistence.load(Build.source_path)

    Build.icons_path.mkpath

    source.teams.each do |team|
      file = Build.icons_path + "#{team.slug}.png"

      unless file.exist?
        puts "Downloading #{team.logo}"
        body = URI.parse("http://am-a.akamaihd.net/image/?f=#{team.logo}&resize=50:50").read
        img = Magick::Image.from_blob(body)[0]
        small = img.resize_to_fit(36, 36)
        small.write(file.to_s)
      end
    end
  end

  def clean
    Build.icons_path.children.each { |file| file.rmtree }
  end

  def build_sprites
    SpriteFactory.run!(
      Build.icons_path.to_s,
      output_style: Build.build_path + 'css' + 'icons.css',
      margin: 1,
      selector: '.'
    )
  end
end