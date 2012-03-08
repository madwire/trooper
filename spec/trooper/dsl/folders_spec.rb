require 'spec_helper'

require 'trooper/dsl/folders'

describe 'Folders' do
  
  before do

    @klass = Class.new do
      include Trooper::DSL::Folders
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
  
  describe 'when calling cd_to' do
    
    it 'should construct an array of commands' do
      @klass.cd 'path'
      @klass.commands.should == ["cd path"]
    end
    
  end
  
  describe 'when calling create_folder' do
    
    it 'should construct an array of commands' do
      @klass.create_folder 'folder'
      @klass.commands.should == ["mkdir -p folder"]
    end

    it 'should construct an array of commands' do
      @klass.mkdir 'folder'
      @klass.commands.should == ["mkdir -p folder"]
    end
    
  end
  
  describe 'when calling delete_folder' do
    
    it 'should construct an array of commands' do
      @klass.delete_folder 'folder'
      @klass.commands.should == ["rm -rf folder"]
    end
    
  end
  
  describe 'when calling cd_to' do
    
    it 'should construct an array of commands' do
      @klass.create_folders 'folder1', 'folder2'
      @klass.commands.should == ["mkdir -p folder1", "mkdir -p folder2"]
    end
    
  end
  
end
