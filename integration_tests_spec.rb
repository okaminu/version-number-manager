describe 'Integration test' do
  let(:content)         { "file_content \n version:1.2.5 \n dependencyA:1.2.5 \n dependencyB:1.2.0" }
  let(:updated_content) { "file_content \n version:1.3.1 \n dependencyA:1.3.1 \n dependencyB:1.2.0" }

  before(:each) do
    File.open('/tmp/config.csv', 'w')   { |f| f.write('test.example,2') }
    File.open('/tmp/test.example', 'w') { |f| f.write(content) }
  end

  after(:each) do
    File.delete('/tmp/config.csv')
    File.delete('/tmp/test.example')
  end

  it 'replaces version numbers in desired file' do
    system 'ruby main.rb /tmp/config.csv 1.2.5 1.3.1 /tmp/'

    expect(File.read('/tmp/test.example')).to eql(updated_content)
  end
end
