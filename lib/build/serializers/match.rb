class Build::Serializers::Match
  def initialize(match)
    @match = match
  end

  def serialize
    {
      stream_url: @match.stream_url,
      vod_urls: @match.vod_urls,
      league_slug: @match.league.slug,
      league_name: @match.league.name,
      team_1_acronym: @match.team_1.acronym,
      team_2_acronym: @match.team_2.acronym,
      team_1_slug: @match.team_1.slug,
      team_2_slug: @match.team_2.slug,
      time: @match.time
    }
  end
end