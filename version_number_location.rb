class VersionNumberLocation
  attr_reader :relative_path, :occurances

  def initialize(path, occurances)
    @relative_path, @occurances = path, occurances
  end
end