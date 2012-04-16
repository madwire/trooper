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
      @strategy2 = Trooper::Strategy.new :another_section, 'another_section_description' do
        actions :another_section_action
      end
      Trooper::Arsenal.strategies.add @strategy2
    end

    after do
      @strategy = nil
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
      @strategy.call(:another_section)
      @strategy.run_list.should == [[:action, :my_action], [:action, :another_section_action]]
    end

    it "should be able to add an actions" do
      @strategy.actions(:my_action, :my_second_action)
      @strategy.run_list.should == [[:action, :my_action], [:action, :my_second_action]]
    end

    it "should be able to add an section to the run list" do
      @strategy.call(:another_section)
      @strategy.run_list.should == [[:action, :another_section_action]]
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

      #actions
      @action = Trooper::Action.new :my_action, 'description' do
        run 'touch test.txt'
      end
      @action2 = Trooper::Action.new :my_action2, 'description' do
        run 'cd ~'
        run 'touch test.txt'
      end
      Trooper::Arsenal.actions.add @action
      Trooper::Arsenal.actions.add @action2

      #setup stratergy
      @configuration = Trooper::Configuration.new({:file_name => "spec/troopfiles/blankfile.rb", :hosts => ['my.servey.com'], :user => 'my_admin_user'})
      @strategy = Trooper::Strategy.new :my_strategy, 'description', @configuration
      @strategy.actions(:my_action)
      @strategy.actions(:my_action2)
    end

    after do
      @strategy = nil
      @action = nil
    end

    it "should execute successfully" do
      ##.should == ['touch test.txt']
      @strategy.execute(@configuration).should == true
    end

  end

  describe "unsuccessful execute spec" do
    before do
      #connection mocking
      mock_net_ssh!
      @connection.stub(:exec!).and_yield(@channel, :stderr, 'Error')

      #actions
      @action = Trooper::Action.new :my_action2, 'description' do
        run 'cd ~'
        run 'touch test.txt'
      end

      Trooper::Arsenal.actions.add @action

      #setup stratergy
      @configuration = Trooper::Configuration.new({:file_name => "spec/troopfiles/blankfile.rb", :hosts => ['my.servey.com'], :user => 'my_admin_user'})
      @strategy = Trooper::Strategy.new :my_strategy, 'description', @configuration
      @strategy.actions(:my_action2)
    end

    after do
      @strategy = nil
      @action = nil
      Trooper::Arsenal.reset!
    end
    
    it "should execute successfully" do
      ##.should == ['touch test.txt']
      @strategy.execute(@configuration).should == false
    end

  end

end