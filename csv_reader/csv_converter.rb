require 'csv'
require_relative '../version_number_location'

class CsvConverter
  def convert(filename)
    locations = []

    CSV.foreach(filename) do |row|
      locations.push(VersionNumberLocation.new(row[0], row[1]))
    end

    locations
  end
end
