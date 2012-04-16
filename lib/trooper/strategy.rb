require 'trooper/runner'

module Trooper
  class Strategy

    attr_reader :name, :description, :config, :run_list
    
    def initialize(name, description, config = {}, &block)
      @name, @description, @config = name, description, config
      @run_list = []
      eval_block(&block)
    end

    def execute(config = {})
      @config = config
      Trooper.logger.debug "Configuration\n#{config}"
      successful = nil

      runners.each do |runner|
        begin
          Trooper.logger.info "\e[4mRunning on #{runner}\n"

          run_list.each do |item, name|
            self.send("#{item}_execute", runner, name)
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

    def ok?
      true
    end

    def call(strategy_name)
      if Arsenal.strategies[strategy_name]
        Arsenal.strategies[strategy_name].run_list.each do |action|
          @run_list << action
        end
      end  
    end

    def actions(*action_names)
      [*action_names].each do |name|
        @run_list << [:action, name]
      end
    end

    def method_missing(method_sym, *arguments, &block)
      config[method_sym] || super
    end

    private

    def eval_block(&block)
      if block_given?
        if block.arity == 1
          block.call self
        else
          instance_eval &block
        end
      end
    end

    def action_execute(runner, name)
      action = Arsenal.actions[name]

      if action
        commands = action.execute config
        Trooper.logger.action action.description
        runner_execute!(runner, commands)
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