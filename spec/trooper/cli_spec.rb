# encoding: utf-8

require 'spec_helper'
require 'trooper/cli'

describe "CLI" do

	describe "with a strategy and environment passed" do
	 
		before do
			# trooper deploy production -d
			@command = 'deploy production -d'
			@cli = Trooper::CLI.start(@command.split(' '))
		end
	 
		it "should determine the strategy to run" do
			@cli.strategy.should == 'deploy'
		end

		it "should determine the environment to run" do
			@cli.environment.should == 'production'
		end

		it "should match the passed options" do
			@cli.options.should == { :debug => true }
		end
	
	end

	describe "without any arguments'" do
	 
		it "should raise an error" do
			lambda { Trooper::CLI.start([]) }.should raise_error(Trooper::CliArgumentError)
			lambda { Trooper::CLI.start("-d".split(' ')) }.should raise_error(Trooper::CliArgumentError)
		end
	
	end

end
