# encoding: utf-8

require 'spec_helper'
require 'trooper/action'

describe "Action" do

  before do
    @action = Trooper::Action.new :my_action, 'description' do
      run "touch #{my_var}.txt"
    end

    @action2 = Trooper::Action.new :my_action, 'description', :local => true do |a|
      a.run 'touch test.txt'
    end

    @action_first_only = Trooper::Action.new :my_action_first, 'description', :on => :first_host do |a|
      a.run 'touch test.txt'
    end

    @action_last_only = Trooper::Action.new :my_action_last, 'description', :on => :last_host do |a|
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
    @action.call(:my_var => 'my_var').should == ['touch my_var.txt']

    @action2.commands.should == []
  end

  it "should validate that an action has all the variables it needs" do
    @action.call(:my_var => 'my_var').should == ['touch my_var.txt']
    lambda { @action.call({}) }.should raise_error(Trooper::InvalidActionError)
  end

  it "should be able to pass a block" do
    @action.call(:my_var => 'my_var')
    @action.commands.should == ['touch my_var.txt']

    @action2.call(:my_var => 'my_var')
    @action2.commands.should == ['touch test.txt']
  end

  it "should not duplicate the commands if called again" do
    @action.call(:my_var => 'my_var')
    @action.commands.should == ['touch my_var.txt']
    @action.call(:my_var => 'my_var')
    @action.commands.should == ['touch my_var.txt']
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

  it "should only run on the first host if :on => first_host option passed" do
    @action_first_only.call(:hosts => ['a','b','c']).should == ['touch test.txt']
    @action_first_only.call(:hosts => ['a','b','c']).should == []
    @action_first_only.call(:hosts => ['a','b','c']).should == []
  end

  it "should only run on the last host if :on => last_host option passed" do
    @action_last_only.call(:hosts => ['a','b','c']).should == []
    @action_last_only.call(:hosts => ['a','b','c']).should == []
    @action_last_only.call(:hosts => ['a','b','c']).should == ['touch test.txt']
  end

end