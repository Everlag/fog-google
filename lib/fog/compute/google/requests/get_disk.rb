module Fog
  module Compute
    class Google
      class Mock
        def get_disk(disk_name, zone_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_disk(disk_name, zone_name)
          zone_name = zone_name.split("/")[-1] if zone_name.start_with? "http"
          @compute.get_disk(@project, zone_name, disk_name)
        end
      end
    end
  end
end
