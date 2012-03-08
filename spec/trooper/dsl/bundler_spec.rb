require 'spec_helper'

require 'trooper/dsl/bundler'

describe 'Bundler' do
  
  before do

    @klass = Class.new do
      include Trooper::DSL::Bundler
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
  
  describe 'with a gemfile' do

    describe 'when calling bundle_install' do
      
      it 'should construct an array of commands' do
        @klass.should_receive(:using_bundler?).and_return(true)
        @klass.should_receive(:path).and_return('path/to')
        
        @klass.bundle_install
        @klass.commands.should == ["bundle install --path path/to/trooper/bundle --deployment --without development test"]
      end
      
    end
    
    describe 'when calling bundle_exec' do
      
      it 'should append a command with "bundle exec" in front' do
        @klass.should_receive(:using_bundler?).and_return(true)
        
        @klass.bundle_exec 'my_command'
        @klass.commands.should == ["bundle exec my_command"]
      end
      
    end
    
  end
  
  describe 'without a gemfile' do
    
    describe 'when calling bundle_exec' do
      
      it 'should append a command with "bundle exec" in front' do
        @klass.should_receive(:using_bundler?).and_return(false)
        
        @klass.bundle_exec 'my_command'
        @klass.commands.should == ["my_command"]
      end
      
    end
    
  end

  describe 'when calling rake' do
    
    it 'should construct an array of commands' do
      @klass.rake 'db:seed'
      @klass.commands.should == ["bundle exec rake db:seed"]
    end
    
  end
  
end
 