Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_TOKEN']

  if ENV['DEVELOPMENT']
    config.enabled = false
  end
end
  