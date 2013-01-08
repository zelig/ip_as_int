# IpAsInt

IP address - integer conversion and activerecord support for ip attribute as integer column.

## Installation

Add this line to your application's Gemfile:

    gem 'ip_as_int'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ip_as_int

## Usage

### IP address - integer conversion

    require 'ip_as_int'
    ip_string = '192.168.0.1'
    ip_int = IpAsInt.ip2int(ip_string)
    ip_string = '192.168.0'
    ip_int = IpAsInt.ip2int(ip_string)
    ip_string = IpAsInt.int2ip(ip_int)

### ActiveRecord IP address attribute as integer column

    class Model < ActiveRecord::Base
      include IpAsInt::IpAddressAttribute
      ip_address :ip # :ip as integer column
      search_methods :ip # to allow squeel to do Model.search(:ip => '192.168.0.1')
    end

Attribute methods are defined to let the ip attribute assigned a string, conversion to integer column is done automatically.

    Model.create(:ip => '192.168.0.1')

a scope to retrieve IP by string is also provided unless `scope: false` option is given.

    Model.ip('192.168.0.1')

a validation of the ip address is set up unless `validation: false` option is given

    Model.create(:ip => '192.168.0')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

- http://basic70tech.wordpress.com/2007/04/13/32-bit-ip-address-to-dotted-notation-in-ruby/
- http://norbauer.com/notebooks/code/notes/storing-ip-addresses-as-integers
