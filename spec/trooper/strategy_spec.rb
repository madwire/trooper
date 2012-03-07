# encoding: utf-8

require 'spec_helper'
require 'trooper/strategy'

describe "Strategy" do

  before do
    @strategy = Trooper::Strategy.new :my_strategy, 'description'
  end

  it "should have a name" do
    @strategy.name.should == :my_strategy
  end

  it "should have a description" do
    @strategy.description.should == 'description'
  end

end