require_relative './version_changer'

VersionChanger.new.change(ARGV[0], ARGV[1], ARGV[2], ARGV[3])
