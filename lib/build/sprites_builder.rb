class Build::SpritesBuilder
  def build
    @groups = Build.grouped_logos

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