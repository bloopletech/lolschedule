class Build::JsonRenderer
  def initialize
    @current_year = Time.now.year
  end

  def render(matches:, leagues:, generated:, data_generated:)
    result = {
      generated: generated,
      data_generated: data_generated,
      streams: render_streams(leagues),
      matches: render_matches(matches),
      logos: render_logos
    }

    return result.to_json
  end

  def render_streams(leagues)
    leagues.reject { |league| league.streams.empty? }.map do |league|
      league.streams.map { |stream| render_stream(league: league, stream: stream) }
    end.flatten
  end

  def render_stream(league:, stream:)
    stream_url = Build::StreamUrl.new(stream['url'])

    {
      tags: [league.slug],
      name: "#{league.brand_name_short(@current_year)}#{" #{stream['id']}" if stream['id']}",
      url: stream_url.url,
    }
  end

  def render_matches(matches)
    matches.sort_by { |match| match.rtime }.map do |match|
      render_match(match)
    end
  end

  def render_match(match)
    year = match.rtime.year

    result = {
      tags: render_tags(match),
      league_name: match.league.brand_name_short(year),
      league_name_long: match.league.brand_name(year),
      time: match.rtime.iso8601
    }

    if match.team?
      result.merge!({
        participant_1_name: match.team_1.acronym,
        participant_1_logo: match.team_1.slug,
        participant_2_name: match.team_2.acronym,
        participant_2_logo: match.team_2.slug
      })
    end

    if match.single?
      result.merge!({
        participant_1_name: match.player_1.name,
        participant_2_name: match.player_2.name
      })
    end

    if match.stream_url
      result.merge!({
        stream: render_stream(league: match.league, stream: match.stream_url)
      })
    end

    if match.vod_urls.any?
      result.merge!({
        vods: render_vods(vod_urls: match.vod_urls)
      })
    end

    result
  end

  def render_vods(vod_urls:)
    vod_urls.map { |vod_url| Build::VodUrl.new(vod_url).to_h }
  end

  def render_tags(match)
    result = [match.league.slug]
    result << 'live' if match.stream_url
    result << 'games' if match.vod_urls.any?
    result << 'spoiler' if match.spoiler?
    result.push(match.team_1.acronym, match.team_2.acronym) if match.team?
    result.push(match.player_1.name, match.player_2.name) if match.single?
    result
  end

  def render_logos
    Build.grouped_logos.map do |group|
      aliases = group.map { |file| file.basename(file.extname).to_s }

      {
        aliases: aliases,
        data: Base64.strict_encode64(group.first.read)
      }
    end
  end
end
