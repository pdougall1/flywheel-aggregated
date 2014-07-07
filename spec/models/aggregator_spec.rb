class DummyClass end

require 'spec_helper'

describe Arregator do

  before(:each) do
    @dummy_class = DummyClass.new
    @dummy_class.extend(Arregator)
  end
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'should have a Report model' do
    expect(@dummy_class).to eq(Report)
  end

end
