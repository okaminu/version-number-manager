require 'csv'
require_relative '../value_object/version_number_location'

class CsvConverter
  def convert(filename)
    locations = []

    CSV.foreach(filename) do |row|
      locations.push(VersionNumberLocation.new(row[0], row[1].to_i))
    end

    locations
  end
end
