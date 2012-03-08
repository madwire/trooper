# encoding: utf-8

require 'spec_helper'

require 'trooper/config/environment'

describe "Config Environment" do

  before do
    @klass = Class.new do
      include Trooper::Config::Environment
    end.new
  end

  it "should be able to call env and set an instant variable" do
    @klass.env :stage do
      "some_value"
    end

    @klass.instance_variable_get("@stage_configuration").should be_a_kind_of(Proc)
  end

end