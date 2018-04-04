if defined?(Rollbar)
  Rollbar.configure do |config|
    config.access_token = ENV['ROLLBAR_TOKEN']
  end
end
