class Build::Icons
  def download
    source = Models::Persistence.load(Build.source_path)

    downloader = Build::IconsDownloader.new(source)
    downloader.download
  end

  def clean
    Build.icons_path.children.each { |file| file.rmtree }
  end

  def build_sprites
    SpriteFactory.run!(
      Build.icons_path.to_s,
      output_image: Build.output_path + 'icons.png',
      output_style: Build.build_path + 'css' + 'icons.css',
      margin: 1,
      selector: '.',
      nocomments: true,
      layout: :packed
    )
  end
end