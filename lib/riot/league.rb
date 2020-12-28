class Riot::League
  def self.parse(response)
    response["data"]["leagues"].map { |league| new(league) }
  end

  def initialize(data)
    @data = data
  end

  def id
    @data["id"]
  end

  def name
    @data["name"]
  end

  def tournament_url
    "#{Riot::Data::TOURNAMENTS_ENDPOINT}#{id}"
  end
end
