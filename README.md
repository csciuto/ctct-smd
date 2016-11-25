# CTCT-SMD

Constant Contact Social Media Digest

This gem can be used to automatically create a Constant Contact email that shows the content of a Facebook page to your subscribers.

## Installation

I haven't checked this into RubyGems yet, so pull down the source and run:

```
bundle
rake build
gem install pkg/ctct_smd-0.1.1.gem
```

Then, you should be able to just require the gem:

```ruby
require 'ctct_smd'
```

## Usage

Here's an example script that will generate an email with up to five posts from two pages a piece from the last week. Check out the ctct_smd_config.rb file for other configurable parameters. Many have defaults.

```ruby

CTCT_SMD.config[:facebook_token] = "Token to connect to Facebook"

CTCT_SMD.config[:constantcontact_key] = "Key to connect to Constant Contact"
CTCT_SMD.config[:constantcontact_token] = "Token to connect to Constant Contact"
CTCT_SMD.config[:constantcontact_reply_email] = "An email address verified in Constant Contact"
CTCT_SMD.config[:constantcontact_from_email] = "An email address verified in Constant Contact"
CTCT_SMD.config[:constantcontact_from_name] = "The name you want to show the email as coming from"  
CTCT_SMD.config[:constantcontact_subject] = "The subject of your email"
CTCT_SMD.config[:constantcontact_message] = "This message appears at the top of your email"

CTCT_SMD.config[:constantcontact_img] = "An image you'd like to show at the top of your email"

CTCT_SMD.config[:facebook_page_limit] = 5 # How many posts from each page to put in the email

CTCT_SMD.logger.level = Logger::DEBUG

facebook_service = CTCT_SMD::FacebookService.new

feeds = [
  CTCT_SMD::FacebookRenderer.render(facebook_service.get_page("Your Facebook Page ID")),
  CTCT_SMD::FacebookRenderer.render(facebook_service.get_page("Another page id")),
]

constantcontact_service = CTCT_SMD::ConstantContactService.new
resp = constantcontact_service.send_email(feeds)

```

This creates a Custom Code email but doesn't actually send it.

## TODO

* There's code in the Facebook client that'll retrieve data from a Facebook Group instead of a Page. However, it's probably not complete and definitely untested. Keep in mind that Facebook's TOS requires you respect user privileges so if you want to try groups, make sure you're using an unauthenticated Facebook access token and are accessing Public groups.
* Perhaps other social media feeds other than Facebook could be added as well?
* Could enhance the Constant Contact Client / Service to actually schedule the email. Right now, it's manual but there is a scheduling API.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/csciuto/ctct_smd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

