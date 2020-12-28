class Seeders::Tournaments
  def initialize(source)
    @source = source
  end

  def seed
    Riot::Data["tournaments"].each do |tournament|
      @source.tournaments << Models::Tournament.new(
        riot_id: tournament.id,
        riot_league_id: tournament.league_id,
        slug: tournament.slug,
        start_time: tournament.start_time,
        end_time: tournament.end_time
      )
    end
  end
end