require 'trooper/runner'

module Trooper
  class Strategy

    attr_reader :name, :description, :config, :run_list
    
    def initialize(name, description, config = {}, &block)
      @name, @description, @config = name, description, config
      @run_list = []
      @block = block if block_given?
    end

    def execute(config = {})
      @config = config
      
      eval_block

      Trooper.logger.debug "Configuration\n#{config}"
      Trooper.logger.strategy description
      successful = nil
      
      runners.each do |runner|
        begin
          Trooper.logger.info "\e[4mRunning on #{runner}\n"

          run_list.each do |strategy, type, name|
            commands = build_commands strategy, type, name
            runner_execute! runner, commands if commands
          end

          successful = true
          Trooper.logger.success "\e[4mAll Actions Completed\n"
        rescue Exception => e
          Trooper.logger.error "#{e.class.to_s} : #{e.message}\n\n#{e.backtrace.join("\n")}"

          successful = false
          break #stop commands running on other servers
        ensure
          runner.close
        end
      end
      
      successful
    end

    def build_run_list
      eval_block
      run_list
    end

    def ok?
      true
    end

    def call(*strategy_names)
      [*strategy_names].each do |strategy_name|
        if Arsenal.strategies[strategy_name]
          Arsenal.strategies[strategy_name].build_run_list.each do |action|
            # strategy_name, type, name
            @run_list << action
          end
        end
      end
    end

    def prerequisites(*strategy_names)
      unless @run_list.detect { |a| a[2] == :prepare_prerequisite }
        @run_list << [@name, :action, :prepare_prerequisite] 
      end
      [*strategy_names].each do |strategy_name|
        if Arsenal.strategies[strategy_name]
          Arsenal.strategies[strategy_name].build_run_list.each do |action|
            # strategy_name, type, name
            @run_list << [action[0], :prerequisite, action[2]]
          end
        end  
      end
    end

    def actions(*action_names)
      [*action_names].each do |name| 
        # strategy_name, type, name
        @run_list << [self.name, :action, name]
      end
    end

    def build_commands(strategy_name, type, action_name)
      action = Arsenal.actions[action_name]

      if action
        commands = action.call config

        case type
        when :prerequisite
          commands << "echo '#{action.name}' >> #{prerequisite_list}"
          commands << "echo '#{action.description}'"
          commands = "touch #{prerequisite_list}; if grep -vz #{action_name} #{prerequisite_list}; then #{commands.join(' && ')}; else echo 'Already Done'; fi"    
          Trooper.logger.action "Prerequisite: #{action.description}"
        else
          Trooper.logger.action action.description
        end
        
        commands
      else
        raise MissingActionError, "Cant find action: #{action_name}"
      end
    end

    def method_missing(method_sym, *arguments, &block)
      config[method_sym] || super
    end

    private

    def eval_block
      if @block
        instance_eval &@block
      end
    end

    def runners
      @runners ||= begin
        r, h, u = [], (hosts rescue nil), (user rescue nil)
        h.each {|host| r << Runner.new(host, user) } if h && u; r
      end
    end

    def runner_execute!(runner, commands, options = {})
      result = runner.execute commands, options
      if result && result[1] == :stdout
        Trooper.logger.info "#{result[2]}\n"
        true
      else 
        false
      end
    end

  end
end