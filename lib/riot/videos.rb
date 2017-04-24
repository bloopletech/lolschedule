class Riot::Videos
  def initialize
  end

  def data
    @data ||= Riot::ApiClient.instance.videos
  end

  def videos
    data['videos'].select { |video| video['locale'] == 'en' }
  end
end
