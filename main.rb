require './version_changer'
require_relative './csv_converter/csv_converter'


if ARGV[3] == nil
  Dir.chdir('..') do
    ARGV[3] = File.expand_path(File.dirname(__FILE__))
  end
end

VersionChanger.new.change(ARGV[0], ARGV[1], ARGV[2], ARGV[3])
