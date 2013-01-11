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

    >> require 'ip_as_int'
    => true
    >> ip_string = '192.168.0.1'
    => "192.168.0.1"
    >> ip_int = IpAsInt.ip2int(ip_string)
    => 3232235521
    >> ip_string = IpAsInt.int2ip(ip_int)
    => "192.168.0.1"

Exceptions on invalid IP address

    >> IpAsInt.ip2int('192.168.0')
    ArgumentError: Invalid IP: need 4 parts
    >> IpAsInt.ip2int('192.168.0.s')
    ArgumentError: Invalid IP: illegal format
    >> IpAsInt.ip2int('192.168.0.256')
    ArgumentError: Invalid IP: integer out of range

### ActiveRecord IP address attribute as integer column

    class Model < ActiveRecord::Base
      include IpAsInt::IpAddressAttribute
      ip_address :ip # :ip as integer column
      search_methods :ip # to allow squeel to do Model.search(:ip => '192.168.0.1')
    end

Attribute methods are defined to let the ip attribute assigned a string, conversion to integer column is done automatically.

    >> m = Model.create(:ip => '192.168.0.1')
    => #<Model id: 1, ip: 3232235521>
    >> m.valid?
    => true
    >> m.reload.ip
    => "192.168.0.1"

a scope to retrieve IP by string is also provided unless `scope: false` option is given.

    >> Model.create(
    ?>   [{ :ip => '192.168.0.1' },
    ?>    { :ip => '192.168.0.2' },
    ?>    { :ip => '192.168.0.3' }
    >>    ])
    => [#<Model id: 3, ip: 3232235521>, #<Model id: 4, ip: 3232235522>, #<Model id: 5, ip: 3232235523>]
    >> Model.ip('192.168.0.1', '192.168.0.2')
    => [#<Model id: 3, ip: 3232235521>, #<Model id: 4, ip: 3232235522>]

a validation of the ip address is set up unless `validation: false` option is given

    >> Model.create!(:ip => '192.168.0')
    ActiveRecord::RecordInvalid: Validation failed: Ip has to be a valid IP address

## Further use 

In fact, you can also use the `IpAsInt::IpAddressAttribute` module with active model only. 

    class Model
      include ActiveModel::Validations
      include ::IpAsInt::IpAddressAttribute
      ip_address :ip
    end

The validator can also be used by itself on an IP attribute irrespective of underlying storage (i.e., even if you use a string column)

    class Model
      # :ip string column
      validates :ip, :ip_address => { :allow_blank => true }
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

- http://basic70tech.wordpress.com/2007/04/13/32-bit-ip-address-to-dotted-notation-in-ruby/
- http://norbauer.com/notebooks/code/notes/storing-ip-addresses-as-integers
