module Fog
  module Storage
    class GoogleJSON
      class Real
        # Lists objects in a bucket matching some criteria.
        #
        # @param bucket [String] name of bucket to list
        # @param options [Hash] optional hash of options
        # @option options [String] :delimiter Delimiter to collapse objects
        #   under to emulate a directory-like mode
        # @option options [Integer] :max_results Maximum number of results to
        #   retrieve
        # @option options [String] :page_token Token to select a particular page
        #   of results
        # @option options [String] :prefix String that an object must begin with
        #   in order to be returned
        # @option options ["full", "noAcl"] :projection Set of properties to
        #   return (defaults to "noAcl")
        # @option options [Boolean] :versions If true, lists all versions of an
        #   object as distinct results (defaults to False)
        def list_objects(bucket, options = {})
          # TODO: handle options
          @storage_json.list_objects(bucket)
        end
      end

      class Mock
        def list_objects(_bucket, _options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
