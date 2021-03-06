require "logger"
require "kafka/connection"
require "kafka/protocol"

module Kafka
  class Broker
    def initialize(connection:, node_id: nil, logger:)
      @connection = connection
      @node_id = node_id
      @logger = logger
    end

    # @return [String]
    def to_s
      "#{@connection} (node_id=#{@node_id.inspect})"
    end

    # @return [nil]
    def disconnect
      @connection.close
    end

    # Fetches cluster metadata from the broker.
    #
    # @param (see Kafka::Protocol::TopicMetadataRequest#initialize)
    # @return [Kafka::Protocol::MetadataResponse]
    def fetch_metadata(**options)
      request = Protocol::TopicMetadataRequest.new(**options)

      @connection.send_request(request)
    end

    # Fetches messages from a specified topic and partition.
    #
    # @param (see Kafka::Protocol::FetchRequest#initialize)
    # @return [Kafka::Protocol::FetchResponse]
    def fetch_messages(**options)
      request = Protocol::FetchRequest.new(**options)

      @connection.send_request(request)
    end

    # Fetches messages asynchronously.
    #
    # The fetch request is sent to the broker, but the response is not read.
    # This allows the broker to process the request, wait for new messages,
    # and send a response without the client having to wait. In order to
    # read the response, call `#call` on the returned object. This will
    # block the caller until the response is available.
    #
    # @param (see Kafka::Protocol::FetchRequest#initialize)
    # @return [Kafka::AsyncResponse]
    def fetch_messages_async(**options)
      request = Protocol::FetchRequest.new(**options)

      @connection.send_async_request(request)
    end

    # Lists the offset of the specified topics and partitions.
    #
    # @param (see Kafka::Protocol::ListOffsetRequest#initialize)
    # @return [Kafka::Protocol::ListOffsetResponse]
    def list_offsets(**options)
      request = Protocol::ListOffsetRequest.new(**options)

      @connection.send_request(request)
    end

    # Produces a set of messages to the broker.
    #
    # @param (see Kafka::Protocol::ProduceRequest#initialize)
    # @return [Kafka::Protocol::ProduceResponse]
    def produce(**options)
      request = Protocol::ProduceRequest.new(**options)

      @connection.send_request(request)
    end

    def fetch_offsets(**options)
      request = Protocol::OffsetFetchRequest.new(**options)

      @connection.send_request(request)
    end

    def commit_offsets(**options)
      request = Protocol::OffsetCommitRequest.new(**options)

      @connection.send_request(request)
    end

    def join_group(**options)
      request = Protocol::JoinGroupRequest.new(**options)

      @connection.send_request(request)
    end

    def sync_group(**options)
      request = Protocol::SyncGroupRequest.new(**options)

      @connection.send_request(request)
    end

    def leave_group(**options)
      request = Protocol::LeaveGroupRequest.new(**options)

      @connection.send_request(request)
    end

    def find_group_coordinator(**options)
      request = Protocol::GroupCoordinatorRequest.new(**options)

      @connection.send_request(request)
    end

    def heartbeat(**options)
      request = Protocol::HeartbeatRequest.new(**options)

      @connection.send_request(request)
    end

    def sasl_handshake(**options)
      request = Protocol::SaslHandshakeRequest(**options)

      @connection.send_request(request)
    end
  end
end
