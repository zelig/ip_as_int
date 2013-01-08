require 'spec_helper'
require 'ip_as_int'

describe ::IpAsInt do

  it "converts ip to int correctly" do
    IpAsInt.ip2int('192.168.0.1').should == 3232235521
  end

  it "converts ip to int correctly" do
    IpAsInt.int2ip(3232235521).should == '192.168.0.1'
  end

  it "throws ArgumentError if ip address is invalid" do
    lambda { IpAsInt.ip2int('192.168.0.OI') }.should raise_error(ArgumentError, "Invalid IP: illegal format")
  end

it "throws ArgumentError if ip address is invalid" do
    lambda { IpAsInt.ip2int('192.168.0.') }.should raise_error(ArgumentError, "Invalid IP: need 4 parts")
  end

  it "throws ArgumentError if ip address is invalid" do
    lambda { IpAsInt.ip2int('192.168.0.257') }.should raise_error(ArgumentError, "Invalid IP: integer out of range")
  end

end
