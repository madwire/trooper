require 'spec_helper'

require 'trooper/dsl/rake'

describe 'Rake' do
  
  before do

    @klass = Class.new do
      include Trooper::DSL::Rake
      attr_accessor :commands

      def initialize
        @commands = []
      end

      def run(command)
        commands << command
      end
    end.new

  end

  after do
    @klass = nil
  end
  
  describe 'when calling rake' do
    
    it 'should construct an array of commands' do
      @klass.should_receive(:ruby_bin_path).and_return('')
      
      @klass.rake 'db:seed'
      @klass.commands.should == ["rake db:seed"]
    end
    
  end
  
end
