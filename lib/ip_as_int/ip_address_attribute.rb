#require 'activemodel/validations'
module IpAsInt
  module IpAddressAttribute

    def self.included(base)
      base.extend IpAddressAttributeClassMethods
    end

    module IpAddressAttributeClassMethods

      def ip_address(*attrs)

        options = attrs.extract_options!
        options = { :scope => true, :validation => true }.merge(options)

        unless new.respond_to?(:read_attribute)
          define_method :read_attribute do |attr|
            instance_variable_get("@#{attr}_raw")
          end
          define_method :write_attribute do |attr,val|
            instance_variable_set("@#{attr}_raw", val)
          end
        end

        attrs.each do |attr|

          define_method "#{attr}=" do |ip_string|
            instance_variable_set("@#{attr}", ip_string)
            ip_int = begin
              if ip_string
                instance_variable_set("@#{attr}_invalid",false)
                ::IpAsInt.ip2int(ip_string)
              end
            rescue ArgumentError
              instance_variable_set("@#{attr}_invalid",true)
              nil
            end
            write_attribute attr, ip_int
          end

          define_method attr do
            if ip_string = instance_variable_get("@#{attr}")
              ip_string
            else
              ip_int =  read_attribute(attr)
              instance_variable_set("@#{attr}",::IpAsInt.int2ip(ip_int)) if ip_int
            end
          end

        end

        if options[:scope] && respond_to?(:where)
          attrs.each do |attr|
            scope attr, (lambda { |*ip_strings|
                           ip_int = ip_strings.map { |ip_string| ::IpAsInt.ip2int(ip_string)  }
                           where(attr => ip_int)
            })
          end
        end

        if options[:validation]
          validates(*(attrs << { :ip_address => options[:validation] }))
        end
      end

    end
  end
end
