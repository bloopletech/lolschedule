class Seeders::League
  LEAGUES = {
    '10' => 'MSI',
    '2' => 'NA LCS',
    '3' => 'EU LCS',
    '6' => 'LCK',
    '7' => 'LPL',
    '8' => 'LMS',
    '4' => 'NA CS',
    '5' => 'EU CS',
    '9' => 'Worlds',
    '1' => 'All-Star',
    '43' => 'Rivals'
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