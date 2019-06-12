require 'csv'

OccurrenceInFile = Struct.new(:relative_path, :occurrences)

class OccurrencesInFilesFactory

  def self.from_csv(csv_file_path)
    occurrences = []

    CSV.foreach(csv_file_path) do |row|
      occurrences.push(OccurrenceInFile.new(row[0], row[1].to_i))
    end

    occurrences
  end

end
