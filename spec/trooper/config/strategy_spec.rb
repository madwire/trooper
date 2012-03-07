# encoding: utf-8

require 'spec_helper'
require 'trooper/cli'

require 'trooper/config/strategy'
require 'trooper/strategies'

describe "Config Strategy" do

  before do
    @klass = Class.new do
      include Trooper::Config::Strategy
    end.new
  end

  after do
    Trooper::Strategies.clear!
  end

  it "should return a Strategy object" do
    @klass.strategy(:my_strategy).should be_a_kind_of(Trooper::Strategy) 
  end

  it "should have added the Strategy object to the Strategies list" do
    Trooper::Strategies[:my_strategy].should be_nil
    @klass.strategy(:my_strategy)
    Trooper::Strategies[:my_strategy].should be_a_kind_of(Trooper::Strategy) 
  end

  it "should overide a strategy in the Strategies list" do
    @klass.strategy(:my_strategy, "A")
    Trooper::Strategies[:my_strategy].description.should == "A"
    @klass.strategy(:my_strategy, "B")
    Trooper::Strategies[:my_strategy].description.should == "B"
  end

end