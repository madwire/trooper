# encoding: utf-8

require 'spec_helper'

require 'trooper/config/action'
require 'trooper/arsenal'

describe "Config Strategy" do

  before do
    @klass = Class.new do
      include Trooper::Config::Action
    end.new
  end

  after do
    Trooper::Arsenal.reset!
  end

  it "should return a Action object" do
    @klass.action(:my_action).should be_a_kind_of(Trooper::Action) 
  end

  it "should have added the Action object to the Actions list" do
    Trooper::Arsenal.actions[:my_action].should be_nil
    @klass.action(:my_action)
    Trooper::Arsenal.actions[:my_action].should be_a_kind_of(Trooper::Action) 
  end

  it "should overide a action in the Actions list" do
    @klass.action(:my_action, "A")
    Trooper::Arsenal.actions[:my_action].description.should == "A"
    @klass.action(:my_action, "B")
    Trooper::Arsenal.actions[:my_action].description.should == "B"
  end

end