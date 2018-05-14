class Riot::Videos
  def initialize
  end

  def data
    Riot::Data['videos']
  end

  def videos
    data['videos'].select { |video| video['locale'] == 'en' }
  end
end
