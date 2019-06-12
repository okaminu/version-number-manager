require 'csv'
require_relative 'occurrences_in_files_factory'

describe OccurrencesInFilesFactory do
  it "converts csv file to occurrences in files" do
    filename = 'data.csv'
    csv_row = ['path', 5]
    allow(CSV).to receive(:foreach).with(filename).and_yield csv_row

    occurrences = OccurrencesInFilesFactory.new.from_csv(filename)

    expect(csv_row[0]).to eql(occurrences[0].relative_path)
    expect(csv_row[1]).to eql(occurrences[0].occurrences)
    expect(occurrences.length).to eql(1)
  end
end