class VersionNumberReplacement
  attr_reader :old_version, :new_version

  def initialize(old_version, new_version)
    @old_version, @new_version = old_version, new_version
  end
end