# encoding: utf-8

require 'spec_helper'
require 'trooper/configuration'
require 'trooper/arsenal'
require 'trooper/strategy'
require 'trooper/runner'
require 'trooper/action'

describe "Runner" do

  describe "hosts specs" do
    before do
      mock_net_ssh!
      configuration = Trooper::Configuration.new({:file_name => "spec/troopfiles/blankfile.rb", :hosts => ['my.servey.com'], :user => 'my_admin_user'})

      @strategy = Trooper::Strategy.new :my_strategy, 'description', configuration
      @runner = Trooper::Runner.new @strategy, configuration
      @runner2 = Trooper::Runner.new @strategy, {}
    end

    after do
      @strategy = nil
      @runner = nil
      @runner2 = nil
    end

    it "should have set of runners available" do
      @runner.send(:hosts).class.should == Array
      @runner.send(:hosts).first.class.should == Trooper::Host
    end

    it "should return a blank array when no hosts are set" do
      @runner2.send(:hosts).should == []
    end
  end

  describe "successful execute specs" do
    before do
      #connection mocking
      mock_net_ssh!
      @connection.stub(:exec!).and_yield(@channel, :stdout, 'Server Name 1')
      #setup stratergy
      @configuration = Trooper::Configuration.new({:file_name => "spec/troopfiles/blankfile.rb", :hosts => ['my.servey.com'], :user => 'my_admin_user', :trooper_path => '/path/trooper', :prerequisite_list => 'prerequisite_list'})
    
      #Trooper::Arsenal.reset!
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

      #Strategies
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

      @runner = Trooper::Runner.new @strategy, @configuration
    end

    it "should execute successfully" do
      @runner.execute.should == true
    end

    it "should build the commands" do
      @runner.send(:build_commands, :my_strategy, :action, :successful_action).should == ["touch test.txt"]
      @runner.send(:build_commands, :another_strategy, :action, :successful_action2).should == ["cd ~", "touch test.txt"]
      @runner.send(:build_commands, :yet_another_strategy, :prerequisite, :successful_action2).should == "touch prerequisite_list; if grep -vz successful_action2 prerequisite_list; then cd ~ && touch test.txt && cd ~ && touch test.txt && echo 'successful_action2' >> prerequisite_list && echo 'description'; else echo 'Already Done'; fi"
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
      @runner = Trooper::Runner.new @strategy, @configuration
    end

    after do
      @strategy = nil
      @unsuccessful_action = nil
      Trooper::Arsenal.reset!
    end
    
    it "should execute successfully" do
      ##.should == ['touch test.txt']
      @runner.execute.should == false
    end

  end

end