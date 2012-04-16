# encoding: utf-8

require "net/ssh"

module Trooper
  class Runner
    
    attr_reader :host, :user, :connection
    
    # pass the host, user and any net/ssh config options
    #   Runner.new('my.example.com', 'admin', :forward_agent => false)
    def initialize(host, user, options = { :forward_agent => true })
      @host = host
      @user = user
      @connection = Net::SSH.start(host, user, options)
    end

    # returns user@host as a string
    def to_s
      "#{user}@#{host}"
    end
    
    # execute a set of commands via net/ssh, returns and array or raises an exception
    #   runner.execute(['cd to/path', 'touch file']) # => ['cd to/path && touch file', :stdout, '']
    #   runner.execute('cat file') # => ['cat file', :stdout, 'file content']
    def execute(command, options = {})
      commands = parse command
      Trooper.logger.debug commands
      connection.exec! commands do |ch, stream, data|
        raise Trooper::StdError, "#{data}\n[ERROR INFO] #{commands}" if stream == :stderr
        ch.wait
        return [commands, stream, data]
      end
    end
    
    # close net/ssh connection
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
