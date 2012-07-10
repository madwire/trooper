# encoding: utf-8

require 'spec_helper'
require 'trooper/host'

describe "Host" do
  
  describe "with valid username and host" do
    before do
      mock_net_ssh!
      @host = ::Trooper::Host.new('server.local','server_admin')
    end

    after do
      @host.close
    end
    
    describe "with string commands" do
      
      it "should return a stdout and message in an array with uname command" do
        connection.should_receive(:exec!).and_yield(channel, :stdout, 'Server Name 1')
        
        result = @host.execute('uname')
        result.class.should equal(Array)
        result[0].should == 'uname'
        result[1].should equal(:stdout)
        result[2].should == 'Server Name 1'
      end
      
      it "should return nil with an blank command" do
        connection.should_receive(:exec!).and_return(nil)
        
        @host.execute('').should equal(nil)
      end
      
    end
    
    describe "with array of commands" do
      
      it "should return a stdout and message in an array with a valid command uname" do
        connection.should_receive(:exec!).and_yield(channel, :stdout, 'Server Name 3')
        
        result = @host.execute(['cd /', nil, 'uname'])
        result.class.should equal(Array)
        result[0].should == 'cd / && uname'
        result[1].should equal(:stdout)
        result[2].should == 'Server Name 3'
      end
      
      it "should return nil with an blank command" do
        connection.should_receive(:exec!).and_return(nil)
        
        command = [nil]
        @host.execute(command).should equal(nil)
      end
      
    end
    
    
    describe "with invalid command" do
      
      it "should raise an Trooper::StdError" do
        connection.should_receive(:exec!).and_yield(channel, :stderr, 'Server Name 5')
        
        lambda { @host.execute('some_command') }.should raise_error(Trooper::StdError)
      end

      it "should raise an Trooper::MalformedCommandError" do
        lambda { @host.execute(1) }.should raise_error(Trooper::MalformedCommandError)
      end
      
    end

    describe "with local string commands" do
      
      it "should return a stdout and message in an array with uname command" do        
        result = @host.execute("pwd", :local => true)
        result.class.should equal(Array)
        result[0].should == "pwd"
        result[1].should equal(:stdout)
        result[2].class.should == String
      end
      
      it "should return nil with an blank command" do
        @host.execute('', :local => true).should equal(nil)
      end

      it "should raise an Trooper::StdError" do  
        lambda { @host.execute('some_command', :local => true) }.should raise_error(Trooper::StdError)
      end
      
    end
    
  end
  
  describe "with invalid username(foobar) and host(foo.bar)" do
    
    it "should raise an SocketError" do
      Net::SSH.stub(:start).and_raise SocketError
      
      lambda { ::Trooper::Host.new('foo.bar','foobar') }.should raise_error(SocketError)
    end
    
  end
 
end
