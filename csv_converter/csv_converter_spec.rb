require 'csv'
require_relative 'csv_converter'

RSpec.describe CsvConverter do
  it "converts csv file to version number locations" do
    filename = 'data.csv'
    csv_row = ['path', 'occurances']
    allow(CSV).to receive(:foreach).with(filename).and_yield csv_row

    documents = CsvConverter.new.convert(filename)

    expect(csv_row[0]).to eql(documents[0].path)
    expect(csv_row[1]).to eql(documents[0].occurances)
    expect(1).to eql(documents.length)
  end
end