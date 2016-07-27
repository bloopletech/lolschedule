RSpec.describe Riot::League, vcr: true do
  let(:league_id) { 2 }
  let(:league) { described_class.new(league_id) }

  describe '#teams' do
    specify { expect(league.teams).to be_a(Array) }

    let(:team) { league.teams.first }
    specify { expect(team).to be_a(Hash) }
    specify { expect(team["id"]).to eq(11) }
    specify { expect(team["acronym"]).to eq("TSM") }
    specify { expect(team["logoUrl"]).to eq("http://assets.lolesports.com/team/team-solomid-er9lau58.png") }
  end

  describe '#tournaments' do
    specify { expect(league.tournaments).to be_a(Array) }

    let(:tournament) { league.tournaments.find { |t| t["title"] =~ /2016/ } }
    specify { expect(tournament).to be_a(Hash) }
    specify { expect(tournament["id"]).to eq("739fc707-a686-4e49-9209-e16a80fd1655") }
    specify { expect(tournament["title"]).to eq("na_2016_spring") }
    specify { expect(tournament["league"]).to eq(league_id.to_s) }
  end
end