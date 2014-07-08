class DummyClass 
end

require 'spec_helper'


describe Aggregator do

  before(:each) do
    vendor = 'citygrid'
    logs = MockData.get_file('citygrid')
    mongoose_logs = MockData.get_file('mongoose')
    braxtel_logs = MockData.get_file('braxtel')
    @log = LogHandler.build_log_row(vendor, logs, mongoose_logs, braxtel_logs)
  end

  subject { @log }

  it { should be_a Log }

  # it 'should have a Report model' do
  #   expect(@log).to eq(Log)
  # end

end
