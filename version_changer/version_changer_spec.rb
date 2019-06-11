require_relative 'version_changer'

describe VersionChanger do

  it 'writes read file content with substituted version numbers' do
    writable_file_spy = instance_double("FileToWrite")
    allow(File).to receive(:read).with("/file/path").and_return "file_content \n version:1.0.0 \n dependencyA:1.0.0"
    allow(File).to receive(:open).with("/file/path", "w").and_yield writable_file_spy

    expect(writable_file_spy).to receive(:write).with "file_content \n version:2.0.0 \n dependencyA:2.0.0"

    VersionChanger.new.substitute("/file/path", "1.0.0", "2.0.0", 2)
  end

  it 'ignores unmatched versions' do
    writable_file_spy = instance_double("FileToWrite")
    allow(File).to receive(:read).with("/file/path").and_return "file_content \n version:1.0.0 \n dependencyA:1.0.0 \n dependencyB:1.2.0"
    allow(File).to receive(:open).with("/file/path", "w").and_yield writable_file_spy

    expect(writable_file_spy).to receive(:write).with "file_content \n version:2.0.0 \n dependencyA:2.0.0 \n dependencyB:1.2.0"

    VersionChanger.new.substitute("/file/path", "1.0.0", "2.0.0", 2)
  end

  it 'substitutes only a known number of version numbers' do
    writable_file_spy = instance_double("FileToWrite")
    allow(File).to receive(:read).with("/file/path").and_return "file_content \n version:1.0.0 \n dependencyA:1.0.0 \n dependencyB:1.2.0"
    allow(File).to receive(:open).with("/file/path", "w").and_yield writable_file_spy

    expect(writable_file_spy).to receive(:write).with "file_content \n version:2.0.0 \n dependencyA:2.0.0 \n dependencyB:1.2.0"

    VersionChanger.new.substitute("/file/path", "1.0.0", "2.0.0", 2)
  end

  it 'throws an error if there is an unexpected number of version numbers found in file' do
    writable_file_spy = instance_double("FileToWrite")
    allow(writable_file_spy).to receive(:write)
    allow(File).to receive(:read).with("/file/path").and_return "file_content \n version:1.0.0 \n dependencyA:1.0.0 \n dependencyB:1.2.0"
    allow(File).to receive(:open).with("/file/path", "w").and_yield writable_file_spy

    expect($stderr).to receive(:puts).with "/file/path contains unexpected count of version numbers, expected 3, got 2"
    expect(writable_file_spy).not_to receive(:write)

    VersionChanger.new.substitute("/file/path", "1.0.0", "2.0.0", 3)
  end

end
