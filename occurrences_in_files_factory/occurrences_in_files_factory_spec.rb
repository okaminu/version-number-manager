require 'csv'
require_relative 'occurrences_in_files_factory'

describe OccurrencesInFilesFactory do
  it 'converts csv file to occurrences in files' do
    filename = 'data.csv'
    expected_occurrences = ['path', 5]
    allow(CSV).to receive(:foreach).with(filename).and_yield expected_occurrences

    actual_occurrences = OccurrencesInFilesFactory.from_csv(filename)

    expect(expected_occurrences[0]).to eql(actual_occurrences[0].relative_path)
    expect(expected_occurrences[1]).to eql(actual_occurrences[0].occurrences)
    expect(actual_occurrences.length).to eql(1)
  end
end
