module Trooper
  class Runner

    attr_reader :strategy, :config, :list

    def initialize(strategy, config)
      @strategy, @config = strategy, config
      @list = strategy.list config
    end

    def execute
      Trooper.logger.debug "Configuration\n#{config}"
      Trooper.logger.strategy strategy.description
      successful = nil
      
      hosts.each do |host|
        begin
          Trooper.logger.info "\e[4mRunning on #{host}\n"

          list.each do |strategy_name, type, name|
            # strategy_name, type, name
            commands = build_commands strategy_name, type, name
            runner_execute! host, commands if commands
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

    def build_commands(strategy_name, type, action_name)
      action = Arsenal.actions[action_name]

      if action
        case type
        when :prerequisite
          commands = action.prerequisite_call config 
          Trooper.logger.action "Prerequisite: #{action.description}"
        else
          commands = action.call config
          Trooper.logger.action action.description
        end
        
        commands
      else
        raise MissingActionError, "Cant find action: #{action_name}"
      end
    end

    def hosts
      @hosts ||= begin
        r, h, u = [], (config[:hosts] rescue nil), (config[:user] rescue nil)
        h.each {|host| r << Host.new(host, u) } if h && u; r
      end
    end

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