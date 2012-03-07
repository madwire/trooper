# encoding: utf-8

require 'spec_helper'
require 'trooper/strategies'

describe "Strategies" do

  before do
    @klass = Class.new do
      attr_accessor :name

      def initialize
        @name = :my_name
      end

      def ok?
        true
      end

    end.new
  end

  after do
    Trooper::Strategies.clear!
  end

  it "should be able to find an object that responds to name" do
    Trooper::Strategies.add @klass
    Trooper::Strategies[:my_name].should == @klass
  end

  it "should be able to add an object to the list" do
    Trooper::Strategies[:my_name].should be_nil
    Trooper::Strategies.add @klass
    Trooper::Strategies[:my_name].should == @klass
  end

  it "should be able to over-write an exsting object with the same name" do
    @klass2 = Class.new do
      attr_accessor :name

      def initialize
        @name = :my_name
      end

      def ok?
        true
      end
    end.new

    Trooper::Strategies.add @klass
    Trooper::Strategies[:my_name].should == @klass

    Trooper::Strategies.add @klass2
    Trooper::Strategies[:my_name].should == @klass2
  end

  it "should reset the array if clear! is called" do
    Trooper::Strategies.add @klass
    Trooper::Strategies.strategies.count.should == 1
    Trooper::Strategies.clear!
    Trooper::Strategies.strategies.count.should == 0
  end

end