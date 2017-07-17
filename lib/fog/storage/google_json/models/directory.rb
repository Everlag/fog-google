module Fog
  module Storage
    class GoogleJSON
      class Directory < Fog::Model
        identity :key, :aliases => ["Name", "name", :name]

        def destroy
          requires :key
          service.delete_bucket(key)
          true
        rescue Fog::Errors::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Storage::GoogleJSON::Files.new(
              :directory => self,
              :service => service
            )
          end
        end

        def public_url
          requires :key
          if key.to_s =~ /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/
            "https://#{key}.storage.googleapis.com"
          end
          "https://storage.googleapis.com/#{key}"
        end

        def save
          requires :key
          options = {}
          options["predefinedAcl"] = attributes[:predefined_acl] if attributes[:predefined_acl]
          options["LocationConstraint"] = @location if @location
          options["StorageClass"] = attributes[:storage_class] if attributes[:storage_class]
          service.put_bucket(key, options)
          true
        end
      end
    end
  end
end
