# encoding: utf-8

require 'spec_helper'
require 'trooper/action'

describe "Action" do

  before do
    @action = Trooper::Action.new :my_action, 'description' do
      run 'touch test.txt'
    end

    @action2 = Trooper::Action.new :my_action, 'description' do |a|
      a.run 'touch test.txt'
    end
  end

  it "should have a name" do
    @action.name.should == :my_action
  end

  it "should have a description" do
    @action.description.should == 'description'
  end

  it "should be able to pass a block" do
    @action.ok?.should == true
    @action.commands.should == ['touch test.txt']

    @action2.ok?.should == true
    @action2.commands.should == ['touch test.txt']
  end

end