require 'csv'
require_relative 'csv_converter'

describe CsvConverter do
  it "converts csv file to version number locations" do
    filename = 'data.csv'
    csv_row = ['path', 5]
    allow(CSV).to receive(:foreach).with(filename).and_yield csv_row

    locations = CsvConverter.new.convert(filename)

    expect(csv_row[0]).to eql(locations[0].relative_path)
    expect(csv_row[1]).to eql(locations[0].occurrences)
    expect(locations.length).to eql(1)
  end
end