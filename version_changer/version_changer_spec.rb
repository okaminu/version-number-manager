require_relative 'version_changer'
require_relative '../occurrences_in_files_factory/occurrences_in_files_factory'

describe VersionChanger do
  VERSION_NUMBER_REPLACEMENT = VersionNumberReplacement.new('1.0.0', '2.0.0').freeze
  CONTENT         = "file_content \n version:1.0.0 \n dependencyA:1.0.0 \n dependencyB:1.2.0".freeze
  UPDATED_CONTENT = "file_content \n version:2.0.0 \n dependencyA:2.0.0 \n dependencyB:1.2.0".freeze

  before(:each) do
    @writable_file_spy = instance_double('FileToWrite')
    allow(File).to receive(:read).with('/base/file.conf').and_return CONTENT
    allow(File).to receive(:open).with('/base/file.conf', 'w').and_yield @writable_file_spy
  end

  it 'updates file content with a known number of substituted version numbers by ignoring unmatched version numbers' do
    allow(OccurrencesInFilesFactory).to receive(:from_csv)
      .with('/csv/path').and_return [OccurrenceInFile.new('file.conf', 2)]

    expect(@writable_file_spy).to receive(:write).with UPDATED_CONTENT

    VersionChanger.new.replace_in_files('/csv/path', VERSION_NUMBER_REPLACEMENT, '/base')
  end

  describe 'throws an error' do
    it 'if more version numbers were matched' do
      allow(OccurrencesInFilesFactory).to receive(:from_csv).and_return [OccurrenceInFile.new('file.conf', 3)]

      expect(@writable_file_spy).not_to receive(:write)
      expect { VersionChanger.new.replace_in_files('/csv/path', VERSION_NUMBER_REPLACEMENT, '/base') }
        .to output("file.conf contains unexpected count of version numbers, expected 3, got 2\n").to_stderr
    end

    it 'if less version numbers were matched' do
      allow(OccurrencesInFilesFactory).to receive(:from_csv).and_return [OccurrenceInFile.new('file.conf', 1)]

      expect(@writable_file_spy).not_to receive(:write)
      expect { VersionChanger.new.replace_in_files('/csv/path', VERSION_NUMBER_REPLACEMENT, '/base') }
        .to output("file.conf contains unexpected count of version numbers, expected 1, got 2\n").to_stderr
    end
  end
end
