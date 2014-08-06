require 'liedetector'


describe LieDetector::Suite do
  it 'should do the task' do
    suite = LieDetector::Suite.new('README.md')
    suite.run
  end
end
