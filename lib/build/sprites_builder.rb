class Build::SpritesBuilder
  def build
    @groups = grouped_logos

    clean
    copy_used
    create_styles
  end

  def clean
    Build.used_logos_path.mkpath
    Build.used_logos_path.children.each { |file| file.rmtree }
  end

  def copy_used
    @groups.each do |group|
      from = group.first
      to = Build.used_logos_path + from.basename
      to.write(from.read)
    end
  end

  def grouped_logos
    group = {}

    Build.logos_path.children.each do |file|
      hash = Magick::Image.read(file.to_s).first.signature
      group[hash] ||= []
      group[hash] << file
    end

    group.values
  end

  def create_styles
    SpriteFactory.run!(
      Build.used_logos_path.to_s,
      output_image: Build.output_path + 'logos.png',
      output_style: Build.build_path + 'css' + 'logos.css',
      margin: 1,
      selector: '.',
      nocomments: true,
      layout: :packed
    ) { |sprites| css_rules(sprites) }
  end

  def css_rules(sprites)
    @groups.map do |group|
      classes = group.map { |file| file.basename(file.extname).to_s }

      sprite = sprites[classes.first.to_sym]

      selector = classes.map { |c| ".#{c}" }.join(", ")

      "#{selector} { #{sprite[:style]} }"
    end.join("\n")
  end
end