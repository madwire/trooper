# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/update_repository_action'

describe "UpdateRepositoryAction" do

  before do
    @action = Trooper::Actions::UpdateRepositoryAction.new
    @config = { :application_path => '/path/to/application', :branch => 'master'}
  end

  it "should be named update_repository" do
    @action.name.should == :update_repository
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["cd /path/to/application", "git checkout master -q", "git pull origin master -q", "git gc --aggressive"]
  end

end