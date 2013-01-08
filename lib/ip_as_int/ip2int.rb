module IpAsInt::Ip2int

  def ip2int(ip_string)
    ip2a(ip_string).pack('C*').unpack('N').first
    #ip_string.split('.').inject(0) { |total,value| (total << 8 ) + value.to_i }
  end

  def int2ip(ip_int)
    if ip_int
      [ip_int].pack('N').unpack('C*').join('.')
      #[24, 16, 8, 0].collect {|b| (address >> b) & 255}.join('.')IpAsInt::
    else
      ""
    end
  end

  def ip2a(ip_string)
    ip_a = ip_string.split('.')
    raise(ArgumentError, "Invalid IP: need 4 parts") unless ip_a.length == 4
    rexp = /^\d+$/
    raise(ArgumentError, "Invalid IP: illegal format") unless ip_a.all? { |x| rexp.match(x) }
    ip_a = ip_a.map(&:to_i)
    raise(ArgumentError, "Invalid IP: integer out of range") unless ip_a.all? { |x| (0..255).include? x }
    ip_a
  end

end
