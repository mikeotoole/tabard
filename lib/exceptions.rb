# This module contains all of our custom exceptions.
module Exceptions
  # This class represents an invalid addition to an association collection.
  class InvalidCollectionAddition < StandardError; end
  # This class represents an invalid removal from an association collection.
  class InvalidCollectionRemoval < StandardError; end
end
