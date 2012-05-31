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
      @strategy.run_list.should == [[:my_strategy, :action, :my_action], [:another_strategy, :action, :another_strategy_action]]
    end

    it "should be able to add an actions" do
      @strategy.actions(:my_action, :my_second_action)
      @strategy.run_list.should == [[:my_strategy, :action, :my_action], [:my_strategy, :action, :my_second_action]]
    end

    it "should be able to add an strategy to the run list" do
      @strategy.call(:another_strategy)
      @strategy.run_list.should == [[:another_strategy, :action, :another_strategy_action]]
    end

    it "should be able to add strategys to the run list" do
      @strategy.call(:another_strategy, :yet_another_strategy)
      @strategy.run_list.should == [[:another_strategy, :action, :another_strategy_action], [:yet_another_strategy, :action, :yet_another_strategy_action]]
    end

    it "should be able to add prerequisites to the run list" do
      @strategy.prerequisites(:another_strategy, :yet_another_strategy)
      @strategy.run_list.should == [[:another_strategy, :prerequisite, :another_strategy_action], [:yet_another_strategy, :prerequisite, :yet_another_strategy_action]]
    end
  end

  describe "runners specs" do
    before do
      mock_net_ssh!
      configuration = Trooper::Configuration.new({:file_name => "spec/troopfiles/blankfile.rb", :hosts => ['my.servey.com'], :user => 'my_admin_user'})

      @strategy = Trooper::Strategy.new :my_strategy, 'description', configuration
      @strategy2 = Trooper::Strategy.new :another_section, 'another_section_description'
    end

    after do
      @strategy = nil
      @strategy2 = nil
    end

    it "should have set of runners available" do
      @strategy.send(:runners).class.should == Array
      @strategy.send(:runners).first.class.should == Trooper::Runner
    end

    it "should return a blank array when no hosts are set" do
      @strategy2.send(:runners).should == []
    end
  end

  describe "successful execute specs" do
    before do
      #connection mocking
      mock_net_ssh!
      @connection.stub(:exec!).and_yield(@channel, :stdout, 'Server Name 1')
      #setup stratergy
      @configuration = Trooper::Configuration.new({:file_name => "spec/troopfiles/blankfile.rb", :hosts => ['my.servey.com'], :user => 'my_admin_user', :prerequisite_list => 'prerequisite_list'})

      Trooper::Arsenal.reset!
      #actions
      @successful_action = Trooper::Action.new :successful_action, 'description' do
        run 'touch test.txt'
      end
      Trooper::Arsenal.actions.add @successful_action
      @successful_action2 = Trooper::Action.new :successful_action2, 'description' do
        run 'cd ~'
        run 'touch test.txt'
      end
      Trooper::Arsenal.actions.add @successful_action2

      @strategy2 = Trooper::Strategy.new :another_strategy, 'another_strategy_description' do
        actions :successful_action2
      end
      Trooper::Arsenal.strategies.add @strategy2

      @strategy3 = Trooper::Strategy.new :yet_another_strategy, 'another_strategy_description' do
        actions :successful_action2
      end
      Trooper::Arsenal.strategies.add @strategy3
      
      @strategy = Trooper::Strategy.new :my_strategy, 'description', @configuration
      @strategy.actions(:successful_action)
      @strategy.call(:another_strategy)
      @strategy.prerequisites(:yet_another_strategy)
    end

    after do
      @strategy = nil
      @action, @action2 = nil
      Trooper::Arsenal.reset!
    end

    it "should execute successfully" do
      @strategy.execute(@configuration).should == true
    end

    it "should build the commands" do
      @strategy.build_commands(:my_strategy, :action, :successful_action).should == ["touch test.txt"]
      @strategy.build_commands(:another_strategy, :action, :successful_action2).should == ["cd ~", "touch test.txt"]
      @strategy.build_commands(:yet_another_strategy, :prerequisite, :successful_action2).should == "touch prerequisite_list; if grep -c my_strategy prerequisite_list; then cd ~ && touch test.txt && cd ~ && touch test.txt; else echo 'Already Done!'; fi"
    end

  end

  describe "unsuccessful execute spec" do
    before do
      #connection mocking
      mock_net_ssh!
      @connection.stub(:exec!).and_yield(@channel, :stderr, 'Error')

      #actions
      @unsuccessful_action = Trooper::Action.new :unsuccessful_action, 'description' do
        run 'cd ~'
        run 'touch test.txt'
      end

      Trooper::Arsenal.actions.add @unsuccessful_action

      #setup stratergy
      @configuration = Trooper::Configuration.new({:file_name => "spec/troopfiles/blankfile.rb", :hosts => ['my.servey.com'], :user => 'my_admin_user'})
      @strategy = Trooper::Strategy.new :my_strategy, 'description', @configuration
      @strategy.actions(:unsuccessful_action)
    end

    after do
      @strategy = nil
      @unsuccessful_action = nil
      Trooper::Arsenal.reset!
    end
    
    it "should execute successfully" do
      ##.should == ['touch test.txt']
      @strategy.execute(@configuration).should == false
    end

  end

end