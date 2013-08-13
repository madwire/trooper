require 'trooper/host'

module Trooper
  class Runner

    attr_reader :strategy, :config, :list

    # Public: initialize a new Runner.
    #
    # strategy - A Trooper::Strategy object to execute.
    # config - A Trooper::Configuration object to use for deployment.
    #
    # Examples
    #
    #   Runner.new(<Strategy>, <Configuration>) # => <Runner>
    #
    # Returns a new Runner object.
    def initialize(strategy, config)
      @strategy, @config = strategy, config
      @list = strategy.list config
    end

    # Public: Executes the strategy across mutiple hosts logging output as it goes.
    #
    # Examples
    #
    #   @runner.execute # => true
    #
    # Returns a boolean.
    def execute
      Trooper.logger.debug "Configuration\n#{config}"
      Trooper.logger.strategy strategy.description
      successful = nil
      
      hosts.each do |host|
        begin
          Trooper.logger.info "\e[4mRunning on #{host}\n"

          list.each do |strategy_name, type, name|
            # strategy_name, type, name
            commands, options = build_commands strategy_name, type, name
            runner_execute! host, commands, options if commands
          end

          successful = true
          Trooper.logger.success "\e[4mAll Actions Completed\n"
        rescue Exception => e
          Trooper.logger.error "#{e.class.to_s} : #{e.message}\n\n#{e.backtrace.join("\n")}"

          successful = false
          break #stop commands running on other servers
        ensure
          host.close
        end
      end
      
      successful
    end

    private

    # build the commands to be sent to the host object
    def build_commands(strategy_name, type, action_name)
      action = Arsenal.actions[action_name]

      if action
        options = action.options

        case type
        when :prerequisite
          commands = action.prerequisite_call config 
          Trooper.logger.action "Prerequisite: #{action.description}"
        else
          commands = action.call config
          Trooper.logger.action action.description
        end
        
        [commands, options]
      else
        raise MissingActionError, "Cant find action: #{action_name}"
      end
    end

    # returns an array of host objects
    def hosts
      @hosts ||= begin
        r, h, u = [], (config[:hosts] rescue nil), (config[:user] rescue nil)
        h.each {|host| r << Host.new(host, u) } if h && u; r
      end
    end

    # runs the commands on a host and deals with output
    def runner_execute!(host, commands, options = {})
      result = host.execute commands, options
      if result && result[1] == :stdout
        Trooper.logger.info "#{result[2]}\n"
        true
      else 
        false
      end
    end

  end
end