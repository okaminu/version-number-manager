class VersionNumberLocation
  attr_reader :relative_path, :occurrences

  def initialize(path, occurrences)
    @relative_path, @occurrences = path, occurrences
  end
end