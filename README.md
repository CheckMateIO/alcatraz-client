# Alcatraz::Client

A client library for the Alcatraz PCI-compliant data store.

## Installation

Add this line to your application's Gemfile:

    gem 'alcatraz-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alcatraz-client

## Usage

You will need your Alcatraz API keys (both public and secret) to use alcatraz-client.

First, set up your connection.

    conn = Alcatraz::Client::Connection.new(public_key: ENV['ALCATRAZ_PUBLIC_KEY'], secret_key: ENV['ALCATRAZ_SECRET_KEY'])

After that you can use any of the public API methods for Alcatraz.

### Store credit card data

The first thing you'll want to do with Alcatraz is store credit card data securely. That's the whole game after all!

    card = conn.store_card!(
      number: '4111111111111111',
      expiration_month: '5',
      expiration_year: '2015',
      cvv: '123',
      postal_code: '94107',
      country_code: 'US'
    )
    card.href # => '/cards/afbfe408-8e66-4e11-aecb-e21825512b16'
    card.number # => '411111******1111'

The Alcatraz API does not technically require any sort of authentication to store data but in the case of this client,
we provide it. Only masked data will be returned from a call to store_card!.

If the card is created successfully it will automatically be authorized to your client.

### Fetch credit card data

You can pull card data back out of Alcatraz.  Depending on your client's level of access, this data may or may not be masked.

    card = conn.get_card('afbfe408-8e66-4e11-aecb-e21825512b16')
    # If your client had decryption access...
    card.number # => '4111111111111111'
    # otherwise...
    card.number # => '411111******1111'

### Store arbitrary secure data

Alcatraz also allows for the storage of arbitrary "secure" data such as social security numbers, passport numbers, etc.

The API to store arbitrary data is almost identical as storing credit card data.

    data = conn.store_data!(
      ssn: '123456789'
    )
    data.href # => '/secure_data/3a5ca937-7a08-434b-8648-4c34986bfb54'
    data.ssn # => '*********'

You'll notice that for arbitrary data, Alcatraz does not do any special processing like it does with credit cards because
we do not know what you are sending in.  For masked data, the values sent in are fully masked instead of partially masked.

### Fetch secure data

Fetching secure data is the same as fetching card data.  Again, depending on your access level, the data may or may not be masked.

    data = conn.get_data('3a5ca937-7a08-434b-8648-4c34986bfb54')
    # With decryption enabled...
    data.ssn # => '123456789'
    # otherwise...
    data.ssn # => '*********'

### Create additional API clients

### Authorize/Deauthorize data to clients


## Contributing

1. Fork it ( http://github.com/<my-github-username>/alcatraz-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
