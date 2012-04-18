# encoding: utf-8

require 'spec_helper'

require 'trooper/config/defaults'

describe "Config Defaults" do

  before do
    @klass = Class.new do
      include Trooper::Config::Defaults

      def initialize
        @config = {}
      end

      def config
        @config
      end

      def load_default_actions!; ; end 
    end.new
  end

  it "should set some default config options" do
    @klass.load_defaults!

    @klass.config[:file_name].should == "Troopfile"
    @klass.config[:environment].should == :production
    @klass.config[:ruby_bin_path].should == ""
  end
end