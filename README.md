# HomeAway API

[![Gem Version](https://badge.fury.io/rb/homeaway-api.svg)](https://badge.fury.io/rb/homeaway-api)

A Ruby SDK to interact with the HomeAway API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'homeaway_api'
```

And then execute in the checked out directory to install into your system gems:

    $ rake install

or to install into your bundle:

    $ bundle exec rake install

## Usage

### Authenticating

In order to use this gem, you must first have a HomeAway API client ID and client secret. Both of these can be obtained by registering yourself as an API developer at https://www.homeaway.com/platform/myClients

Once you have these credentials, to use this gem:

```ruby
require 'homeaway_api'
client = HomeAway::API::Client.new(client_id: your_client_id, client_secret: your_client_secret)
```

This will automatically have your client authenticate with HomeAway. If you wish to have your application be able to access the personal HomeAway data of the user of your application, you need to call:

```ruby
client.auth_url
```

which will return back a URL as a String that the user of your application must be sent to. It is up to you to define how that takes place. Once your user goes to that url they will prompted to login with their HomeAway credentials. As soon as they do that and authorize your application to access their HomeAway data, the client's web browser will be redirected back to the redirect url that you specified when you created your client above. This url will have a code appended to it as a parameter named code. Once you are able to grab that code, you can use it with this gem:

```ruby
client.oauth_code = code_received_from_redirect_url
```

As soon as you make that assignment, the client will contact HomeAway and obtain a token that can be used for interacting with the HomeAway for that user for that particular session. By default, this token has a 6 month expiration time.

### Using an existing token

If you have a token string saved from a previous use of the HomeAway API it can be reused with this SDK to avoid having your user login to HomeAway again.

```ruby
client = HomeAway::API::Client.new(
      token: 'saved_token_value'
  )
```

### Custom configuring the client

You will usually not need to do this often as the defaults will be sufficient for most use cases, but if necessary, you can specify any subset of the fields below:

```ruby
client.configure do |c|
    site: <site>, #override the hostname of the api
    port: <port>, #defaults to 443
    logger: <logger_instance>, #supply your own custom logger instance
    cache_control: <value>, #set a custom cache control header to be sent on each request
    auto_pagination: <true or false>, #will paginated resources automatically traverse their pages when being iterated over
    connection_opts: <opts>, #set any connection options to the underlying Faraday connection object, must be a hash
    page_size: <size>, #overwrite the default page size (10)
    test_mode: <true or false> #enable or disable test mode, default disabled
end
```

##  Operations

Each of the operations is detailed in the generated Yard documentation for this gem. 

##  Quickstart

```ruby
require 'homeaway_api'
client = HomeAway::API::Client.new(client_id: your_client_id, client_secret: your_client_secret)
response = @client.get_listing '123456', ['AVAILABILITY', 'RATES']
paginator = @client.search '4 bathrooms new york'
paginator.each do |search_result|
  listing =  @client.get_listing search_result.listing_id, ['DETAILS', 'RATES', 'LOCATION']
  puts listing
end
```

##  hacurl

If you install this gem, it will also install a command line utility named `hacurl`. `hacurl` is a tool that allows developers to easily interact with the HomeAway API without writing a single line of code. The available options:

```
$ Usage: hacurl [options] url
    -i, --client-id CLIENT_ID        your client id
    -s CLIENT_SECRET,                your client secret
        --client-secret
    -e, --email EMAIL                optional email address to use for operations that require 3-legged-oauth
    -p, --password PASSWORD          optional password to use for operations that require 3-legged-oauth
    -d, --data FILE                  path to file for any operations that require a body (PUT OR POST)
    -X, --method METHOD              method to send (GET, PUT, POST)
    -a, --get-auth                   only output the bearer authorization
    -v, --verbose                    print verbose information
    -t, --traveler                   login as a traveler
    -o, --owner                      login as an owner (the default)
```

An example invocation would be:

```
$ hacurl -i <your_client_id> -s <your_client_secret> /public/listing?id=123456
```

## Other

The full API documentation is located at: https://homeaway.com/platform/documentation

## Contributing

1. Fork it https://github.com/homeaway/homeaway_api_ruby
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
