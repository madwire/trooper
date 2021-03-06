require 'trooper/version'
require 'trooper/logger'

module Trooper
  
  # Base class for all Trooper exceptions
  class TrooperError < StandardError
  end

  # When a strategy is not defined
  class MissingStrategyError < TrooperError
  end

  # When a acton is not defined
  class MissingActionError < TrooperError
  end

  # When a CLI argument is missing or badly formed
  class CliArgumentError < TrooperError
  end

  # When a command(s) return a stderr stream
  class StdError < TrooperError
  end

  # When a command is not formed corrently, arrays or strings are exceptal commands
  class MalformedCommandError < TrooperError
  end

  # When a configuration file is missing
  class NoConfigurationFileError < TrooperError
  end

  # When an action is invalid
  class InvalidActionError < TrooperError
  end

end