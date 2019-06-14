describe 'Integration tests' do
  let(:content)         { "file_content \n version:1.2.5 \n dependencyA:1.2.5 \n dependencyB:1.2.0" }
  let(:updated_content) { "file_content \n version:1.3.1 \n dependencyA:1.3.1 \n dependencyB:1.2.0" }

  context 'by providing all the necessary arguments' do
    before(:each) { create_temp_files('/tmp') }
    after(:each) { delete_temp_files('/tmp') }

    it 'replaces version numbers in desired file' do
      system 'ruby main.rb /tmp/config.csv 1.2.5 1.3.1 /tmp/'

      expect(File.read('/tmp/test.example')).to eql(updated_content)
    end
  end

  context 'by omitting base path argument' do
    before(:each) { create_temp_files(Dir.pwd, "#{File.basename(Dir.getwd)}/") }
    after(:each) { delete_temp_files(Dir.pwd) }

    it 'replaces version numbers in desired file, searched from parent directory' do
      system "ruby main.rb #{Dir.pwd}/config.csv 1.2.5 1.3.1"

      expect(File.read("#{Dir.pwd}/test.example")).to eql(updated_content)
    end
  end

  def create_temp_files(directory, subject_subdirectory = '')
    File.open("#{directory}/config.csv", 'w')   { |f| f.write("#{subject_subdirectory}test.example,2") }
    File.open("#{directory}/test.example", 'w') { |f| f.write(content) }
  end

  def delete_temp_files(directory)
    File.delete("#{directory}/config.csv")
    File.delete("#{directory}/test.example")
  end
end
