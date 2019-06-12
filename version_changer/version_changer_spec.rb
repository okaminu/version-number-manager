require_relative 'version_changer'
require_relative '../csv_converter/occurrences_in_files_factory'

describe "VersionChanger" do

  CURRENT_VERSION = "1.0.0"
  NEW_VERSION     = "2.0.0"
  CONTENT         = "file_content \n version:1.0.0 \n dependencyA:1.0.0 \n dependencyB:1.2.0"
  UPDATED_CONTENT = "file_content \n version:2.0.0 \n dependencyA:2.0.0 \n dependencyB:1.2.0"

  before(:each) do
    @occurrences_factory_stub = instance_double("CsvConverter")
    @writable_file_spy = instance_double("FileToWrite")

    allow(OccurrencesInFilesFactory).to receive(:new).and_return @occurrences_factory_stub
  end

  it 'updates file content with a known number of substituted version numbers by ignoring unmatched version numbers' do
    allow(@occurrences_factory_stub).to receive(:from_csv).and_return [OccurrenceInFile.new("file.conf", 2)]
    allow(File).to receive(:read).with("/base/file.conf").and_return CONTENT
    allow(File).to receive(:open).with("/base/file.conf", "w").and_yield @writable_file_spy

    expect(@writable_file_spy).to receive(:write).with UPDATED_CONTENT

    replace_in_files("/csv/path", VersionNumberReplacement.new(CURRENT_VERSION, NEW_VERSION), '/base')
  end

  it 'throws an error if more version numbers were matched' do
    allow(@occurrences_factory_stub).to receive(:from_csv).and_return [OccurrenceInFile.new("file.conf", 3)]
    allow(File).to receive(:read).with("/base/file.conf").and_return CONTENT
    allow(File).to receive(:open).with("/base/file.conf", "w").and_yield @writable_file_spy

    expect($stderr).to receive(:puts).with "file.conf contains unexpected count of version numbers, expected 3, got 2"
    expect(@writable_file_spy).not_to receive(:write)

    replace_in_files("/csv/path", VersionNumberReplacement.new(CURRENT_VERSION, NEW_VERSION), '/base')
  end

  it 'throws an error if less version numbers were matched' do
    allow(@occurrences_factory_stub).to receive(:from_csv).and_return [OccurrenceInFile.new("file.conf", 1)]
    allow(File).to receive(:read).with("/base/file.conf").and_return CONTENT
    allow(File).to receive(:open).with("/base/file.conf", "w").and_yield @writable_file_spy

    expect($stderr).to receive(:puts).with "file.conf contains unexpected count of version numbers, expected 1, got 2"
    expect(@writable_file_spy).not_to receive(:write)

    replace_in_files("/csv/path", VersionNumberReplacement.new(CURRENT_VERSION, NEW_VERSION), '/base')
  end

  it 'uses parent path of this project if the base path is not provided' do
    pending
    allow(@occurrences_factory_stub).to receive(:from_csv).and_return [OccurrenceInFile.new("file.conf", 2)]
    allow(File).to receive(:read).with("../file.conf").and_return CONTENT
    allow(File).to receive(:open).with("../file.conf", "w").and_yield @writable_file_spy

    expect(@writable_file_spy).to receive(:write).with UPDATED_CONTENT

    replace_in_files("/csv/path", VersionNumberReplacement.new(CURRENT_VERSION, NEW_VERSION), nil)
  end
end
