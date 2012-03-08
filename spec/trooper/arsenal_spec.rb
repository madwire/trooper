# encoding: utf-8

require 'spec_helper'
require 'trooper/arsenal'

describe "Arsenal" do

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
    Trooper::Arsenal.reset!
  end

  it "should be able to find an object that responds to name" do
    Trooper::Arsenal.strategies.add @klass
    Trooper::Arsenal.strategies[:my_name].should == @klass
  end

  it "should be able to add an object to the list" do
    Trooper::Arsenal.strategies[:my_name].should be_nil
    Trooper::Arsenal.strategies.add @klass
    Trooper::Arsenal.strategies[:my_name].should == @klass
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

    Trooper::Arsenal.strategies.add @klass
    Trooper::Arsenal.strategies[:my_name].should == @klass

    Trooper::Arsenal.strategies.add @klass2
    Trooper::Arsenal.strategies[:my_name].should == @klass2
  end

  it "should reset the array if clear! is called" do
    Trooper::Arsenal.strategies.add @klass
    Trooper::Arsenal.strategies.count.should == 1
    Trooper::Arsenal.strategies.clear!
    Trooper::Arsenal.strategies.count.should == 0
  end

end