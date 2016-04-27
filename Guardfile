require_relative './lib/lolschedule.rb'
icons_proc = proc do |icons, _, files|
  puts "Downloading icons"
  icons.download
end

icons_options = {
  object: Build::Icons.new,
  run_on_additions: icons_proc,
  run_on_modifications: icons_proc,
  run_on_removals: icons_proc,
  run_on_changes: icons_proc
}

guard :yield, icons_options do
  watch(%r{^data/.*$})
end

sprites_proc = proc do |icons, _, files|
  puts "Building sprites"
  icons.build_sprites
end

sprites_options = {
  object: Build::Icons.new,
  run_on_additions: sprites_proc,
  run_on_modifications: sprites_proc,
  run_on_removals: sprites_proc,
  run_on_changes: sprites_proc
}

guard :yield, sprites_options do
  watch(%r{^build/icons/.*$})
end

build_proc = proc do |builder, _, files|
  puts "Building site"
  builder.build
end
build_options = {
  object: Build::Html.new,
  run_on_additions: build_proc,
  run_on_modifications: build_proc,
  run_on_removals: build_proc,
  run_on_changes: build_proc
}

guard :yield, build_options do
  watch(%r{^build/.*$})
  watch(%r{^data/.*$})
end

guard 'livereload' do
  watch(%r{^output/.*$})
end