class Seeders::League
  LEAGUES = {
    '2' => 'NA LCS',
    '3' => 'EU LCS',
    '6' => 'LCK',
    '7' => 'LPL',
    '8' => 'LMS',
    '13' => 'OPL',
    '4' => 'NA CS',
    '5' => 'EU CS'
  }

  def initialize(source)
    @source = source
  end

  def seed
    LEAGUES.each_pair do |id, name|
      @source.leagues << Models::League.new(riot_id: id, name: name)
    end
  end
end