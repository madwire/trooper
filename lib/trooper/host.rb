# encoding: utf-8

require "net/ssh"

module Trooper
  class Host
    
    attr_reader :host, :user, :connection
    
    # Public: Initialize a new Host object.
    #
    # host - The String of the host location
    # user - The String of the user name.
    # options - The Hash of options to pass into Net::SSH
    #           see Net::SSH for details (default: { :forward_agent => true })
    #
    # Examples
    #
    #   Host.new('my.example.com', 'admin', :forward_agent => false)
    #
    # Returns a Host object.
    def initialize(host, user, options = { :forward_agent => true })
      @host = host
      @user = user
      @connection = Net::SSH.start(host, user, options)
    end

    # Public: Friendly version of the object.
    #
    # Examples
    #
    #   @host.to_s # => 'foo@bar.com'
    #
    # Returns user@host as a String.
    def to_s
      "#{user}@#{host}"
    end
    
    # Public: Execute a set of commands via net/ssh.
    #
    # command - A String or Array of command to run on a remote server
    # options - Not currently implemented.
    #
    # Examples
    #
    #   runner.execute(['cd to/path', 'touch file']) # => ['cd to/path && touch file', :stdout, '']
    #   runner.execute('cat file') # => ['cat file', :stdout, 'file content']
    #
    # Returns an array or raises an exception.
    def execute(command, options = {})
      commands = parse command
      Trooper.logger.debug commands
      connection.exec! commands do |ch, stream, data|
        raise Trooper::StdError, "#{data}\n[ERROR INFO] #{commands}" if stream == :stderr
        ch.wait
        return [commands, stream, data]
      end
    end
    
    # Public: Close net/ssh connection.
    #
    # Examples
    #
    #   @host.close # => true
    #
    # Returns boolean.
    def close
      connection.close
    end
    
    private 
    
    # parse command, expects a string or array
    #   parse(['cd to/path', 'touch file']) # => 'cd to/path && touch file'
    def parse(command)
      case command.class.name.downcase.to_sym #Array => :array
      when :array
        command.compact.join(' && ')
      when :string
        command.chomp
      else
        raise Trooper::MalformedCommandError, "Command Not a String or Array: #{command.inspect}"
      end
    end
    
  end
end
