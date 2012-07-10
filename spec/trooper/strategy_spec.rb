# encoding: utf-8

require 'spec_helper'
require 'trooper/configuration'
require 'trooper/arsenal'
require 'trooper/strategy'
require 'trooper/action'

describe "Strategy" do

  describe "basic specs" do
    before do
      configuration = Trooper::Configuration.new({:file_name => "spec/troopfiles/blankfile.rb", :random => 1})

      [:my_action, :my_second_action, :another_strategy_action, :yet_another_strategy_action].each do |action_name|
        action = Trooper::Action.new action_name, 'description' do
          run 'touch test.txt'
        end
        Trooper::Arsenal.actions.add action
      end

      action = Trooper::Action.new :my_local_action, 'description', :local => true do
        run 'touch test.txt'
      end
      Trooper::Arsenal.actions.add action
      
      @strategy = Trooper::Strategy.new :my_strategy, 'description', configuration
      Trooper::Arsenal.strategies.add @strategy
      
      @strategy2 = Trooper::Strategy.new :another_strategy, 'another_strategy_description' do
        actions :another_strategy_action
      end
      Trooper::Arsenal.strategies.add @strategy2
      @strategy3 = Trooper::Strategy.new :yet_another_strategy, 'another_strategy_description' do
        actions :yet_another_strategy_action
      end
      Trooper::Arsenal.strategies.add @strategy3

      @strategy4 = Trooper::Strategy.new :strategy_with_local_action, 'another_strategy_description' do
        actions :another_strategy_action, :my_local_action
      end
      Trooper::Arsenal.strategies.add @strategy4
    end

    after do
      @strategy, @strategy2, @strategy3 = nil
    end

    it "should have a name" do
      @strategy.name.should == :my_strategy
    end

    it "should have a description" do
      @strategy.description.should == 'description'
    end

    it "should have method access to configuration" do
      @strategy.random.should == 1
    end

    it "should be able to add to the run list" do
      @strategy.actions(:my_action)
      @strategy.call(:another_strategy)
      @strategy.list.should == [[:my_strategy, :action, :my_action], [:another_strategy, :action, :another_strategy_action]]
    end

    it "should be able to add an actions" do
      @strategy.actions(:my_action, :my_second_action)
      @strategy.list.should == [[:my_strategy, :action, :my_action], [:my_strategy, :action, :my_second_action]]
    end

    it "should be able to add an strategy to the run list" do
      @strategy.call(:another_strategy)
      @strategy.list.should == [[:another_strategy, :action, :another_strategy_action]]
    end

    it "should be able to add strategys to the run list" do
      @strategy.call(:another_strategy, :yet_another_strategy)
      @strategy.list.should == [[:another_strategy, :action, :another_strategy_action], [:yet_another_strategy, :action, :yet_another_strategy_action]]
    end

    it "should be able to add prerequisites to the run list" do
      @strategy.prerequisites(:another_strategy, :yet_another_strategy)
      @strategy.list.should == [[:my_strategy, :action, :prepare_prerequisite], [:another_strategy, :prerequisite, :another_strategy_action], [:yet_another_strategy, :prerequisite, :yet_another_strategy_action]]
    end

    it "should be able to add prerequisites to the front of the run list" do
      @strategy.actions(:my_action)
      @strategy.prerequisites(:another_strategy)
      @strategy.list.should == [[:my_strategy, :action, :prepare_prerequisite], [:another_strategy, :prerequisite, :another_strategy_action], [:my_strategy, :action, :my_action]]
    end

    it 'should be able to define an action only available inside the strategy scope' do
      @strategy.action :my_new_action, 'does something' do
        run 'touch file'
      end
      @strategy.list.should == [[:my_strategy, :action, :my_strategy_my_new_action]]
    end

    it "should not be able to add a prerequisite that has a local action" do
      lambda { @strategy.prerequisites(:strategy_with_local_action) }.should raise_error(Trooper::InvalidActionError)
    end


  end
end