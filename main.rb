require_relative 'version_changer/version_changer'

replace_in_files(ARGV[0], VersionNumberReplacement.new(ARGV[1], ARGV[2]), ARGV[3] || "..")
