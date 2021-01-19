class Seeders::StreamEvents
  def initialize(source)
    @source = source
  end

  def seed
    Riot::Data["stream_events"].each { |event| seed_stream_event(event) }
  end

  def seed_stream_event(event)
    league = @source.leagues.find(event.league_id)
    return unless league
    league.stream_match_ids ||= []
    league.stream_match_ids << event.id
    event.streams.each { |stream| seed_stream(stream, league) }
  end

  def seed_stream(stream, league)
    league.streams << {
      'id' => stream_id(stream),
      'url' => { provider: stream.provider, id: stream.parameter, start: stream.offset.to_s },
      priority: 0
    }
  end

  def stream_id(stream)
    case stream.provider
    when "youtube"
      "YouTube"
    when "twitch"
      "Twitch"
    else
      ""
    end
  end
end
