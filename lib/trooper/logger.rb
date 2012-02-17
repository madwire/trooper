# encoding: utf-8

require 'logger'

module Trooper

  class LogFormat

  	COLOURS = { 
	    :black		=> 30,
	    :red			=> 31, 
	    :green		=> 32, 
	    :yellow		=> 33,
	    :blue			=> 34,
	    :magenta	=> 35,
	    :cyan			=> 36,
	    :white		=> 37
	  }

	  def call(severity, datetime, progname, message)
	  	# DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
	  	case severity
	  	when "DEBUG"
	  		colour("#{progname}[#{severity}] => #{message}\n", :yellow)
	  	when "WARN"
	  		colour("#{progname} [#{severity}] => #{message}\n", :yellow)
			when "ERROR", "FATAL"
				colour("#{progname} [#{severity}] => #{message}\n", :red)
			else
	  		"#{progname} [#{severity}] => #{message}\n"
	  	end
	  end

		private

		def colour(msg, clr = :black)
			"\e[#{COLOURS[clr]}m#{msg}\e[0m"
		end
  	
  end


  def self.logger
  	@logger ||= begin
  		logger = ::Logger.new($stdout)
  		logger.progname = 'Trooper'
  		logger.formatter = LogFormat.new
  		logger
  	end
  end


end
