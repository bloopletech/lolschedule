class Riot::League
  def initialize(league_id)
    @league_id = league_id
  end

  def data
    Riot::Data["league_#{@league_id}"]
  end

  def teams
    data['teams']
  end

  def players
    data['players']
  end

  def tournaments
    data['highlanderTournaments'].reverse.uniq { |t| t['title'] }
  end

  def published_tournaments
    tournaments.select { |t| t['published'] || current_tournament?(t) }
  end

  def current_tournament?(tournament)
    return false unless tournament['startDate']
    Date.strptime(tournament['startDate'], '%Y-%m-%d').year >= 2019
  end

  def schedule_items(tournament_id = nil)
    if tournament_id
      data['scheduleItems'].select { |s| s['tournament'] == tournament_id }
    else
      data['scheduleItems']
    end
  end
end
