# This is a copy from ActiveSupport::CoreExtensions::Numeric

module Merb
  module Helpers
    module SizeHelpers
      module Bytes
        def bytes
          self
        end
        alias :byte :bytes

        def kilobytes
          self * 1024
        end
        alias :kilobyte :kilobytes

        def megabytes
          self * 1024.kilobytes
        end
        alias :megabyte :megabytes

        def gigabytes
          self * 1024.megabytes 
        end
        alias :gigabyte :gigabytes

        def terabytes
          self * 1024.gigabytes
        end
        alias :terabyte :terabytes

        def petabytes
          self * 1024.terabytes
        end
        alias :petabyte :petabytes

        def exabytes
          self * 1024.petabytes
        end
        alias :exabyte :exabytes  
      end
      
      def human_size(size, precision=1)
        size = Kernel.Float(size)
        case
          when size.to_i == 1;    "1 Byte"
          when size < 1.kilobyte; "%d Bytes" % size
          when size < 1.megabyte; "%.#{precision}f KB"  % (size / 1.0.kilobyte)
          when size < 1.gigabyte; "%.#{precision}f MB"  % (size / 1.0.megabyte)
          when size < 1.terabyte; "%.#{precision}f GB"  % (size / 1.0.gigabyte)
          else                    "%.#{precision}f TB"  % (size / 1.0.terabyte)
        end.sub(/([0-9]\.\d*?)0+ /, '\1 ' ).sub(/\. /,' ')
      rescue
        nil
      end
    end
  end
end

class Numeric
  include Merb::Helpers::SizeHelpers::Bytes
end