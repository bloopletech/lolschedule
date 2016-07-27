VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :excon

  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
end