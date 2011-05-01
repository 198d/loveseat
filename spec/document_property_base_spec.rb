require 'spec_helper'

describe Loveseat::Document::Property::Base do
  include Loveseat::Document::Property
  
  it 'assigns value' do
    'value'.should == Base.new('value').value     
  end

  it 'gets the value' do
    'value'.should == Base.new('value').get
  end

  it 'sets the value' do
    base = Base.new('value')
    base.set('new value')
    'new value'.should == base.get
  end
  
  it 'is empty if the value is nil' do
    Base.new.empty?.should be_true
  end

  it 'is not empty if the value is set' do
    Base.new('value').empty?.should be_false
  end
end
