# encoding: utf-8

require 'spec_helper'
require 'trooper/configuration'

require 'trooper/config/action'

describe "Configuration" do

  describe "with the a configuration file" do
   
    before do
      @configuration = Trooper::Configuration.new(:file_name => "spec/troopfiles/default.rb" , :my_var => 1)
    end

    it "should load the configuration file" do
      @configuration.loaded?.should == true
    end

    it "should load the configuration file" do
      @configuration.loaded?.should == true
    end

    it "should be able to access passed options" do
      @configuration[:my_var].should == 1
    end

    it "should set new options" do
      @configuration[:my_new_option].should == nil
      @configuration.set :my_new_option => 'new_option'
      @configuration[:my_new_option].should == 'new_option'
    end

    it "should re-set an option" do
      @configuration.set :my_new_option => 'new_option'
      @configuration[:my_new_option].should == 'new_option'

      @configuration.set :my_new_option => 'new_option2'
      @configuration[:my_new_option].should == 'new_option2'
    end

    it "should have loaded some default actions" do
      Trooper::Arsenal.reset!
      @configuration.load_default_actions!
      Trooper::Arsenal.actions.count.should == Trooper::Config::Action::DEFAULT_ACTIONS.count
    end

    it "should give me a new instance of Trooper::Runner when calling runner" do
      @configuration.runner(:deploy).class.should == Trooper::Runner
    end

  end

  describe "with diffent configuration files" do

    it "should raise an error if configuration if just bad" do
      lambda { Trooper::Configuration.new(:file_name => "spec/troopfiles/no_method.rb") }.should raise_error(NoMethodError)
    end

    it "should raise NoConfigurationFileError if no file exists" do
      lambda { Trooper::Configuration.new(:file_name => "somemadeup.rb") }.should raise_error(Trooper::NoConfigurationFileError)
    end

  end


  describe "with the default(stage) configuration file" do
   
    before do
      @configuration = Trooper::Configuration.new(:file_name => "spec/troopfiles/default.rb" , :environment => :stage)
    end

    it "should have set user" do
      @configuration[:user].should  == 'my_user'
    end

    it "should have set hosts" do
      @configuration[:hosts].should  == ['stage.example.com']
    end

    it "should have set repository" do
      @configuration[:repository].should  == 'git@git.bar.co.uk:whatever.git'
    end

    it "should have set path" do
      @configuration[:path].should  == "/path/to/data/folder"

      @configuration[:application_path].should  == "/path/to/data/folder/application"
      @configuration[:trooper_path].should  == "/path/to/data/folder/trooper"
      @configuration[:prerequisite_list].should  == "/path/to/data/folder/trooper/prerequisite_list"
    end

    it "should have set my_value" do
      @configuration[:my_value].should  == 'something'
    end

    it "should import another file and eval its content" do
      @configuration[:file_imported].should == true
    end

  end

  describe "with the default(production) configuration file" do
   
    before do
      @configuration = Trooper::Configuration.new(:file_name => "spec/troopfiles/default.rb")
    end

    it "should have set hosts" do
      @configuration[:hosts].should  == ['production1.example.com', 'production2.example.com']
    end

    it "should have set my_value" do
      @configuration[:my_value].should  == 'something_else'
    end

    it "should have 3 strategies in its arsenal" do
      Trooper::Arsenal.strategies.count.should == 4
    end

    it "should have 8 defaults and 1 custom action in its arsenal" do
      Trooper::Arsenal.actions.count.should == (Trooper::Config::Action::DEFAULT_ACTIONS.count + 1)
    end

    it "should import another file and eval its content" do
      @configuration[:file_imported].should == true
      @configuration[:hello_world].should == 'hello'
    end

  end

end
