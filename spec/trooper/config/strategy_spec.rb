# encoding: utf-8

require 'spec_helper'

require 'trooper/config/strategy'
require 'trooper/arsenal'

describe "Config Strategy" do

  before do
    @klass = Class.new do
      include Trooper::Config::Strategy
    end.new
  end

  after do
    Trooper::Arsenal.reset!
  end

  it "should return a Strategy object" do
    @klass.strategy(:my_strategy).should be_a_kind_of(Trooper::Strategy) 
  end

  it "should have added the Strategy object to the Strategies list" do
    Trooper::Arsenal.strategies[:my_strategy].should be_nil
    @klass.strategy(:my_strategy)
    Trooper::Arsenal.strategies[:my_strategy].should be_a_kind_of(Trooper::Strategy) 
  end

  it "should overide a strategy in the Strategies list" do
    @klass.strategy(:my_strategy, "A")
    Trooper::Arsenal.strategies[:my_strategy].description.should == "A"
    @klass.strategy(:my_strategy, "B")
    Trooper::Arsenal.strategies[:my_strategy].description.should == "B"
  end

end