class Riot::Streams
  def initialize
  end

  def data
    @data ||= Riot::ApiClient.instance.livestreams
  end

  def streamgroups
    data['streamgroups']
  end

  def active_streamgroups
    data['streamgroups'].select { |group| group['live'] }
  end

  def streams(group_id = nil)
    if group_id
      data['streams'].select { |stream| stream['streamgroups'].any? { |id| id == group_id } }
    else
      data['streams']
    end
  end

  def youtube_streams(streams)
    streams.select { |stream| stream['provider'] == 'youtube' && stream['locale'] == 'en' }
  end

  def active_matches
    Hash[data['highlanderTournaments'].map { |tournament| [tournament['league'], tournament['liveMatches']] }]
  end
end