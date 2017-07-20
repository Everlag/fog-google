module Fog
  module Compute
    class Google
      class Mock
        def insert_disk(disk_name, zone_name, image_name = nil, options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_disk(disk_name, zone_name, image_name = nil, opts = {})
          # According to Google docs, if image name is not present, only one of
          # sizeGb or sourceSnapshot need to be present, one will create blank
          # disk of desired size, other will create disk from snapshot
          if image_name.nil?
            if opts.key?("sourceSnapshot")
              # New disk from snapshot
              snap = snapshots.get(opts.delete("sourceSnapshot"))
              raise ArgumentError.new("Invalid source snapshot") unless snap
              body_object["sourceSnapshot"] = @api_url + snap.resource_url
            elsif opts.key?("sizeGb")
              # New blank disk
              body_object["sizeGb"] = opts.delete("sizeGb")
            else
              raise ArgumentError.new("Must specify image OR snapshot OR "\
                                      "disk size when creating a disk.")
            end
          end

          disk = ::Google::Apis::ComputeV1::Disk.new(
            :name => disk_name,
            :description => options["description"],
            :type => options["type"],
            :size_gb => options["sizeGb"],
            source_snapshot => options["sourceSnapshot"]
          )
          @compute.insert_disk(@project, zone_name, disk,
                               :source_image => image_name)

          api_method = @compute.disks.insert
          parameters = {
            "project" => @project,
            "zone" => zone_name
          }

          if image_name
            # New disk from image
            image = images.get(image_name)
            raise ArgumentError.new("Invalid image specified: #{image_name}") unless image
            @image_url = @api_url + image.resource_url
            parameters["sourceImage"] = @image_url
          end

          body_object = { "name" => disk_name }
          body_object["type"] = opts.delete("type")

          # Merge in any remaining options (only 'description' should remain)
          body_object.merge!(opts)

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
