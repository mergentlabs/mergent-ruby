# Mergent Ruby Library

[![Gem Version](https://badge.fury.io/rb/mergent.svg)](https://badge.fury.io/rb/mergent)
[![CI](https://github.com/mergentlabs/mergent-ruby/actions/workflows/ci.yml/badge.svg)](https://github.com/mergentlabs/mergent-ruby/actions/workflows/ci.yml)

The Mergent Ruby library provides convenient access to the Mergent API from
applications written in the Ruby language.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "mergent"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mergent

## Usage

The library needs to be configured with your project's API key. Set
`Mergent.api_key` to its value:

```ruby
# set the Mergent API key
Mergent.api_key = "..."

# create a Task
task = Mergent::Task.create({ request: { url: "https://example.com" } })

# get the newly created Task's name
task.name
```

See the [Mergent Ruby docs](https://docs.mergent.co/libraries/ruby) for more
details.

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run
`rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the changelog, bump the version number in
`version.rb`, commit that change, and then run `bundle exec rake release`, which
will create a git tag for the version, push git commits and the created tag, and
push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/mergentlabs/mergent-ruby.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
