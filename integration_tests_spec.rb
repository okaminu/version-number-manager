require 'tempfile'

describe 'Integration test' do
  let(:content)         { "file_content \n version:1.2.5 \n dependencyA:1.2.5 \n dependencyB:1.2.0" }
  let(:updated_content) { "file_content \n version:1.3.1 \n dependencyA:1.3.1 \n dependencyB:1.2.0" }

  before(:each) do
    File.open('/tmp/test.csv', 'w')  { |f| f.write('test.test,2') }
    File.open('/tmp/test.test', 'w') { |f| f.write(content) }
  end

  after(:each) do
    File.delete('/tmp/test.csv')
    File.delete('/tmp/test.test')
  end

  it 'replace version numbers in desired files' do
    system 'ruby main.rb /tmp/test.csv 1.2.5 1.3.1 /tmp/'

    expect(File.read('/tmp/test.test')).to eql(updated_content)
  end
end
