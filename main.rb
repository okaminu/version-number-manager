require_relative 'version_changer/version_changer'
require_relative 'value_object/version_number_replacement'

VersionChanger.new.run(ARGV[0], VersionNumberReplacement.new(ARGV[1], ARGV[2]), ARGV[3])
