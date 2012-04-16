# encoding: utf-8

require 'logger'

module Trooper

  class Logger < ::Logger
    ACTION = 6
    SUCCESS = 7
    STRATEGY = 8

    # DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN < ACTION < SUCCESS < STRATEGY
    LABELS = %w(DEBUG INFO WARN ERROR FATAL ANY ACTION SUCCESS STRATEGY)

    def action(progname = nil, &block)
      add(ACTION, nil, progname, &block)
    end

    def success(progname = nil, &block)
      add(SUCCESS, nil, progname, &block)
    end

    def strategy(progname = nil, &block)
      add(STRATEGY, nil, progname, &block)
    end

    private

    def format_severity(severity)
      LABELS[severity] || 'ANY'
    end

  end
  

  class LogFormat

    COLOURS = { 
      :black    => 30,
      :red      => 31, 
      :green    => 32, 
      :yellow   => 33,
      :blue     => 34,
      :magenta  => 35,
      :cyan     => 36,
      :white    => 37
    }

    def call(severity, datetime, progname, message)
      # DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN < ACTION < SUCCESS
      case severity
      when "DEBUG"
        colour("#{progname} => [#{severity}] #{message}\n", :yellow)
      when "WARN"
        colour("#{progname} => [#{severity}] #{message}\n", :yellow)
      when "ACTION"
        colour("#{progname} => [#{severity}] #{message}\n", :magenta)
      when "SUCCESS"
        colour("#{progname} => [#{severity}] #{message}\n", :green)
      when "STRATEGY"
        colour("#{progname} => [#{severity}] #{message}\n", :cyan)
      when "ERROR", "FATAL"
        colour("#{progname} => [#{severity}] #{message}\n", :red)
      else
        "#{progname} => [#{severity}] #{message}\n"
      end
    end

    private

    def colour(msg, clr = :black)
      "\e[#{COLOURS[clr]}m#{msg}\e[0m"
    end

    def underline
      "\e[4m"
    end
    
  end

  def self.logger
    @logger ||= begin
      logger = Logger.new($stdout)
      logger.level = $trooper_log_level || ::Logger::INFO
      logger.progname = 'Trooper'
      logger.formatter = LogFormat.new
      logger
    end
  end


end
