# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/clone_repository_action'

describe "CloneRepositoryAction" do

  before do
    @action = Trooper::Actions::CloneRepositoryAction.new
    @config = {:path => '/path/to', :repository => 'git@example.com:my_repo.git'}
  end

  it "should be named clone_repository" do
    @action.name.should == :clone_repository
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["cd /path/to", "git clone git@example.com:my_repo.git application"]
  end

end