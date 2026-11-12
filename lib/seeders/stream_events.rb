class Seeders::StreamEvents
  def initialize(store, riot_data)
    @store = store
    @riot_data = riot_data
  end

  def seed
    @riot_data.stream_events.each { |event| seed_stream_event(event) }
  end

  def seed_stream_event(event)
    league = @store.leagues.find(event.league_id)
    return unless league
    league.stream_match_ids ||= []
    league.stream_match_ids << event.id

    stream = best_stream(event.streams)
    return unless stream
    seed_stream(stream, league)
  end

  def best_stream(streams)
    stream = streams.find { |stream| stream.english? && stream.youtube? }
    return stream if stream

    stream = streams.find(&:english?)
    return stream if stream

    stream = streams.find(&:youtube?)
    return stream if stream

    streams.first
  end

  def seed_stream(stream, league)
    league.streams << {
      "id" => nil,
      "url" => { provider: stream.provider, id: stream.parameter, start: stream.offset.to_s },
      priority: 0
    }
  end
end
