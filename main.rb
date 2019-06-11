require './version_changer'
require_relative './csv_converter/csv_converter'

VersionChanger.new.change(ARGV[0], ARGV[1], ARGV[2], ARGV[3])
