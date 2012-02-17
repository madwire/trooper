require 'trooper/version'
require 'trooper/logger'

module Trooper
	
	# Base class for all Trooper exceptions
  class TrooperError < StandardError
  end

  # When a strategy is not defined
  class MissingStrategyError < TrooperError
  end

  # When a CLI argument is missing or badly formed
  class CliArgumentError < TrooperError
  end

end