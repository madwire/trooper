# encoding: utf-8

require 'spec_helper'
require 'trooper/action'

describe "Action" do

  before do
    @action = Trooper::Action.new :my_action, 'description'
  end

  it "should have a name" do
    @action.name.should == :my_action
  end

  it "should have a description" do
    @action.description.should == 'description'
  end

end