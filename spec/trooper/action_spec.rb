# encoding: utf-8

require 'spec_helper'
require 'trooper/action'

describe "Action" do

  before do
    @action = Trooper::Action.new :my_action, 'description' do
      run 'touch test.txt'
    end

    @action2 = Trooper::Action.new :my_action, 'description', :local => true do |a|
      a.run 'touch test.txt'
    end
  end

  after do
    @action, @action2 = nil
  end

  it "should have a name" do
    @action.name.should == :my_action
  end

  it "should have a description" do
    @action.description.should == 'description'
  end

  it "should be able to call the action after init" do
    @action.call(:my_var => 'my_var').should == ['touch test.txt']

    @action2.commands.should == []
  end

  it "should be able to pass a block" do
    @action.call(:my_var => 'my_var')
    @action.commands.should == ['touch test.txt']

    @action2.call(:my_var => 'my_var')
    @action2.commands.should == ['touch test.txt']
  end

  it "should not duplicate the commands if called again" do
    @action.call(:my_var => 'my_var')
    @action.commands.should == ['touch test.txt']
    @action.call(:my_var => 'my_var')
    @action.commands.should == ['touch test.txt']
  end

  it "should add strings to the commands array" do
    @action.commands.clear

    @action.run 'my_command1'
    @action.commands.should == ["my_command1"]
    @action.run 'my_command2'
    @action.commands.should == ["my_command1", "my_command2"]
  end

  it "should be able to call config variables" do
    @action.call(:my_var => 'my_var')
    @action.my_var.should == 'my_var'
    lambda { @action2.my_var.should == 'my_var' }.should raise_error(NoMethodError)
  end

  it "should be able to tell something what type it is" do
    @action.type.should == :action
    @action2.type.should == :local_action
  end

end