require_relative 'version_changer'
require_relative '../occurrences_in_files_factory/occurrences_in_files_factory'

describe VersionChanger do
  let(:version_number_replacement) { VersionNumberReplacement.new('1.0.0', '2.0.0') }
  let(:content)         { "file_content \n version:1.0.0 \n dependencyA:1.0.0 \n dependencyB:1.2.0" }
  let(:updated_content) { "file_content \n version:2.0.0 \n dependencyA:2.0.0 \n dependencyB:1.2.0" }

  before(:each) do
    @writable_file_spy = instance_double('FileToWrite')
    allow(File).to receive(:read).with('/base/file.conf').and_return content
    allow(File).to receive(:open).with('/base/file.conf', 'w').and_yield @writable_file_spy
  end

  it 'updates file content with a known number of substituted version numbers by ignoring unmatched version numbers' do
    allow(OccurrencesInFilesFactory).to receive(:from_csv)
      .with('/csv/path').and_return [OccurrenceInFile.new('file.conf', 2)]

    expect(@writable_file_spy).to receive(:write).with updated_content

    VersionChanger.new.replace_in_files('/csv/path', version_number_replacement, '/base/')
  end

  describe 'throws an error' do
    it 'if more version numbers were matched' do
      allow(OccurrencesInFilesFactory).to receive(:from_csv).and_return [OccurrenceInFile.new('file.conf', 3)]

      expect(@writable_file_spy).not_to receive(:write)
      expect { VersionChanger.new.replace_in_files('/csv/path', version_number_replacement, '/base/') }
        .to output("file.conf contains unexpected count of version numbers, expected 3, got 2\n").to_stderr
    end

    it 'if less version numbers were matched' do
      allow(OccurrencesInFilesFactory).to receive(:from_csv).and_return [OccurrenceInFile.new('file.conf', 1)]

      expect(@writable_file_spy).not_to receive(:write)
      expect { VersionChanger.new.replace_in_files('/csv/path', version_number_replacement, '/base/') }
        .to output("file.conf contains unexpected count of version numbers, expected 1, got 2\n").to_stderr
    end
  end
end
