# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/default_action'

describe "DefaultAction" do

  before do
    class MyDefaultAction < Trooper::Actions::DefaultAction
      name :my_default_action
      description 'Cool default action'
      options :local => false, :on => :last_host
    end
    @config = {:path => '/path/to', :repository => 'git@example.com:my_repo.git'}
    @action = MyDefaultAction.new
  end

  it "should have a name" do
    @action.name.should == :my_default_action
  end

  it "should have a description" do
    @action.description.should == 'Cool default action'
  end

  it 'should have some options set' do
    @action.options.should == {:local => false, :on => :last_host}
  end

  it "should return an array of commands" do
    @action.call(@config).should == []
  end

end