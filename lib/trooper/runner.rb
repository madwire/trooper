# encoding: utf-8

require "net/ssh"

module Trooper
  class Runner
    
    attr_reader :host, :user, :connection
    
    def initialize(host, user, options = { :forward_agent => true })
      @host = host
      @user = user
      @connection = Net::SSH.start(host, user, options)
    end
    
    def execute(command, options = {})
      commands = parse command
      connection.exec! commands do |ch, stream, data|
        raise Trooper::StdError, "#{user}@#{host}: #{commands} → #{data}" if stream == :stderr
        ch.wait
        return [commands, stream, data]
      end
    end
    
    def close
      connection.close
    end
    
    private 
    
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
