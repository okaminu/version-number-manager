class VersionNumberLocation
  attr_reader :path, :occurances

  def initialize(path, occurances)
    @path, @occurances = path, occurances
  end
end