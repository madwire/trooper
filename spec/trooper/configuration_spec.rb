# encoding: utf-8

require 'spec_helper'
require 'trooper/configuration'

describe "Configuration" do

  describe "with the default configuration file" do
   
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

    it "should raise an error if configuration if just bad" do
    	lambda { Trooper::Configuration.new(:file_name => "spec/troopfiles/no_method.rb") }.should raise_error(NoMethodError)
    end

    it "should raise NoConfigurationFileError if no file exists" do
    	lambda { Trooper::Configuration.new(:file_name => "somemadeup.rb") }.should raise_error(Trooper::NoConfigurationFileError)
    end

  end

end
