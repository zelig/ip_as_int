require 'active_model/validator'
class IpAddressValidator < ActiveModel::EachValidator
  def validate_each(record, attr, value)
    invalid = instance_variable_get("@#{attr}_invalid")
    invalid = begin
      ::IpAsInt.ip2a(value)
      false
    rescue
      true
    end if invalid.nil?
    record.errors.add(attr,"has to be a valid IP address") if invalid
  end
end
