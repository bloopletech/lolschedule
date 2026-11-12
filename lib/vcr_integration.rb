if ENV["LOLSCHEDULE_ENV"] == "development" && ENV["VCR"] == "true"
  SyncedStdout.puts "Using VCR to record and play back requests."

  VCR.configure do |c|
    c.cassette_library_dir = "vcr_cassettes"
    c.hook_into :excon

    c.default_cassette_options = {
      record: :new_episodes,
      allow_playback_repeats: true,
      preserve_exact_body_bytes: true,
      re_record_interval: 3600 * 24 * 30
    }

    c.ignore_request do |request|
      request.uri.include?("getLive")
    end
  end

  VCR.insert_cassette("default")

  at_exit { VCR.eject_cassette }
end
