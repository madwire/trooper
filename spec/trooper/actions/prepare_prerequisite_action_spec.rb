# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/prepare_prerequisite_action'

describe "PreparePrerequisiteAction" do

  before do
    @action = Trooper::Actions::PreparePrerequisiteAction.new
    @config = { :path => '/path', :trooper_path => '/path/trooper', :prerequisite_list => "/path/trooper/prerequisite_list" }
  end

  it "should be named prepare_prerequisite" do
    @action.name.should == :prepare_prerequisite
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["mkdir -p /path/trooper", "echo 'prepare_prerequisite' >> /path/trooper/prerequisite_list", "echo -e \"Prerequisites Prepared\""]
  end

end