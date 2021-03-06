# encoding: utf-8
module Dynamoid

  # All the errors specific to Dynamoid.  The goal is to mimic ActiveRecord.
  module Errors

    # Generic Dynamoid error
    class Error < StandardError; end

    class MissingRangeKey < Error; end

    # This class is intended to be private to Dynamoid.
    class ConditionalCheckFailedException < Error
      attr_reader :inner_exception

      def initialize(inner)
        super
        @inner_exception = inner
      end
    end

    class RecordNotUnique < ConditionalCheckFailedException
      attr_reader :original_exception

      def initialize(original_exception, record)
        super("Attempted to write record #{record} when its key already exists")
        @original_exception = original_exception
      end
    end

    class StaleObjectError < ConditionalCheckFailedException
      attr_reader :record, :attempted_action

      def initialize(record, attempted_action)
        super("Attempted to #{attempted_action} a stale object #{record}")
        @record = record
        @attempted_action = attempted_action
      end
    end

    class DocumentNotValid < Error
      def initialize(document)
        super("Validation failed: #{document.errors.full_messages.join(", ")}")
      end
    end

    class InvalidQuery < Error; end

    class BatchLimitExceeded < Error
      def initialize
        super("Batch limit is 100")
      end
    end
  end
end
