require_relative 'version_changer'
require_relative '../csv_converter/csv_converter'

describe VersionChanger do

  $converter_stub

  before(:each) do
    $converter_stub = instance_double("CsvConverter")
    allow(CsvConverter).to receive(:new).and_return $converter_stub
  end

  it 'writes read file content with known number of substituted version numbers' do
    allow($converter_stub).to receive(:convert).and_return [VersionNumberLocation.new("file.conf", 2)]
    writable_file_spy = instance_double("FileToWrite")
    allow(File).to receive(:read).with("/base/file.conf").and_return "file_content \n version:1.0.0 \n dependencyA:1.0.0"
    allow(File).to receive(:open).with("/base/file.conf", "w").and_yield writable_file_spy


    expect(writable_file_spy).to receive(:write).with "file_content \n version:2.0.0 \n dependencyA:2.0.0"

    VersionChanger.new.change("/csv/path", "1.0.0", "2.0.0", '/base')
  end

  it 'ignores unmatched versions' do
    allow($converter_stub).to receive(:convert).and_return [VersionNumberLocation.new("file.conf", 2)]
    writable_file_spy = instance_double("FileToWrite")
    allow(File).to receive(:read).with("/base/file.conf").and_return "file_content \n version:1.0.0 \n dependencyA:1.0.0 \n dependencyB:1.2.0"
    allow(File).to receive(:open).with("/base/file.conf", "w").and_yield writable_file_spy

    expect(writable_file_spy).to receive(:write).with "file_content \n version:2.0.0 \n dependencyA:2.0.0 \n dependencyB:1.2.0"

    VersionChanger.new.change("/csv/path", "1.0.0", "2.0.0", '/base')
  end

  it 'throws an error if there is an unexpected number of version numbers found in file' do
    allow($converter_stub).to receive(:convert).and_return [VersionNumberLocation.new("file.conf", 3)]
    writable_file_spy = instance_double("FileToWrite")
    allow(writable_file_spy).to receive(:write)
    allow(File).to receive(:read).with("/base/file.conf").and_return "file_content \n version:1.0.0 \n dependencyA:1.0.0 \n dependencyB:1.2.0"
    allow(File).to receive(:open).with("/base/file.conf", "w").and_yield writable_file_spy

    expect($stderr).to receive(:puts).with "file.conf contains unexpected count of version numbers, expected 3, got 2"
    expect(writable_file_spy).not_to receive(:write)

    VersionChanger.new.change("/csv/path", "1.0.0", "2.0.0", '/base')
  end

  it 'uses parent path of this project, if the base path is not provided' do
    allow($converter_stub).to receive(:convert).and_return [VersionNumberLocation.new("file.conf", 2)]
    writable_file_spy = instance_double("FileToWrite")
    allow(writable_file_spy).to receive(:write)
    allow(File).to receive(:read).with("../file.conf").and_return "file_content \n version:1.0.0 \n dependencyA:1.0.0 \n dependencyB:1.2.0"
    allow(File).to receive(:open).with("../file.conf", "w").and_yield writable_file_spy

    expect(writable_file_spy).to receive(:write).with "file_content \n version:2.0.0 \n dependencyA:2.0.0 \n dependencyB:1.2.0"

    VersionChanger.new.change("/csv/path", "1.0.0", "2.0.0", nil)
  end
end
