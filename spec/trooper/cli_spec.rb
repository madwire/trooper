# encoding: utf-8

require 'spec_helper'
require 'trooper/cli'

describe "CLI" do

  describe "with a strategy and environment passed" do
   
    before do
      # trooper deploy -e production -d
      @command = 'deploy -e production -d'
      @cli = Trooper::CLI.new(@command.split(' '))
    end
   
    it "should determine the strategy to run" do
      @cli.command.should == 'deploy'
    end

    it "should match the passed options" do
      @cli.options.should == { :debug => true, :environment => :production }
    end
  
  end

  describe "with a strategy and no environment passed" do
   
    before do
      # trooper deploy
      @command = 'deploy'
      @cli = Trooper::CLI.new(@command.split(' '))
    end
   
    it "should determine the strategy to run" do
      @cli.command.should == 'deploy'
    end

    it "should have a default environment" do
      @cli.options[:environment].should == :production
    end
  
  end

  describe "without any arguments'" do
   
    it "should raise an error" do
      lambda { Trooper::CLI.new([]) }.should raise_error(Trooper::CliArgumentError)
      lambda { Trooper::CLI.new("-d".split(' ')) }.should raise_error(Trooper::CliArgumentError)
    end
  
  end

end
