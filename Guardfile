require_relative './lib/lolschedule.rb'

def yield_hash(object, &block)
  run_proc = proc do |*args|
    begin
      block.call(*args)
    rescue => e
      puts "Error: #{e.message}\n#{e.backtrace.join("\n")}"
    end
  end

  {
    object: object,
    run_on_additions: run_proc,
    run_on_modifications: run_proc,
    run_on_removals: run_proc
  }
end


icons_options = yield_hash(Build::Icons.new) { |icons| icons.download }
sprites_options = yield_hash(Build::Icons.new) { |icons| icons.build_sprites }
build_options = yield_hash(Build::Html.new) { |builder| builder.build }

guard :yield, icons_options do
  watch(%r{^data/.*$})
end

guard :yield, sprites_options do
  watch(%r{^build/icons/.*$})
end

guard :yield, build_options do
  watch(%r{^build/.*$})
  watch(%r{^data/.*$})
end

guard 'livereload' do
  watch(%r{^output/.*$})
end