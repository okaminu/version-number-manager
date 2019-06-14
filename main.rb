require_relative 'app/version_changer'

VersionChanger.new.replace_in_files(ARGV[0], VersionNumberReplacement.new(ARGV[1], ARGV[2]), ARGV[3] || '../')
