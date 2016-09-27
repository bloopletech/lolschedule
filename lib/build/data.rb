class Build::Data
  def build
    Build.data_json_path.write(data.to_json)
  end
  
  def data
    source = Models::Persistence.load(Build.source_path)

    {
      leagues: Build::Serializers::Leagues.new(source.leagues).serialize,
      matches: Build::Serializers::Matches.new(source.matches.sort_by { |match| match.rtime }).serialize
    }
  end
end