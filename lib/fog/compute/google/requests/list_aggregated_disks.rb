module Fog
  module Compute
    class Google
      class Mock
        def list_aggregated_disks(options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_aggregated_disks(options = {})
          @compute.list_aggregated_disk(@project, :filter => options[:filter])
        end
      end
    end
  end
end
