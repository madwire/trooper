# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/precompile_assets_action'

describe "PrecompileAssetsAction" do

  before do
    @action = Trooper::Actions::PrecompileAssetsAction.new
    @config = {}
  end

  it "should be named clone_repository" do
    @action.name.should == :precompile_assets
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["bundle exec rake assets:precompile RAILS_ENV=production RAILS_GROUPS=assets"]
  end

end