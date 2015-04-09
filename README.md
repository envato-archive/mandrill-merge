Mandrill Merge - Making Mailouts Magnificent!
============================

We all hate spam, but sometimes you need to get an important message out to a large group of people. [Mandrill](https://mandrillapp.com) is great at allowing you to define templates, sending emails out, and keeping track of sends and responses. But how do you get the data from your database over to Mandrill quickly and easily? That's where MandrillMerge comes in...

Current Features
--------

* An intuitive interface that guides you through the process
* Connection to Mandrill via your test or production [Mandrill API keys](https://mandrillapp.com/settings/index)
* Connection to your Database (MySQL only so far)
* A prompt for what columns you need to select from your DB, to fill the placeholders in your chosen template
* A view of the data returned from your DB
* Sends a test email to Mandrill (if you choose a test Mandrill API key) or to a single email address you enter (if you choose a production Mandrill API key)

Coming Soon...
--------------

* Retrieved data is sent to Mandrill in batches for mass email sending
* History of your chosen API keys, templates and SQL queries
* Preview of emails that will be sent, in your browser
* CI server

Development Status
------------------

Still very much a work in progress (see above).

Problems or suggestions?
------------------------

Add to our [issues list](https://github.com/envato/mandrill-merge/issues)

Contributing
------------

For bug fixes, documentation changes, and small features:  

1. Fork it ( https://github.com/envato/mandrill-merge/fork )  
2. Create your feature branch (`git checkout -b my-new-feature`)  
3. Commit your changes (`git commit -am 'Add some feature'`)  
4. Push to the branch (`git push origin my-new-feature`)  
5. Create a new Pull Request

Anything else, please contact [the maintainers](https://github.com/envato/mandrill-merge#maintainers).

Code of Conduct
---------------
Please read our [Code of Conduct](https://github.com/envato/mandrill-merge/blob/master/CODE_OF_CONDUCT.md)

Install
-------

Clone the repo  
```
git clone https://github.com/envato/mandrill-merge
```

Change directory into the project repo  
```
cd mandrill-merge
```

Install gems  
```
bundle install
```

Create an environment file for development
```
echo '#' > .env
```

Run
---

Start the Sinatra server  
```
rackup config.ru
```
### Browse to [http://localhost:5555/](http://localhost:5555/)

Set up your DB connectivity
---------------------------

(coming soon)

Rake tasks!
-----------

Run the specs  
```
rake spec
```

Tech Stack
-------

* [Dave Worth's Mailchimp gem](https://github.com/daveworth/mailchimp-gem) which wraps [HttParty](https://github.com/jnunemaker/httparty) and the [Mandrill API](https://mandrillapp.com/api/docs/)
* [Ruby](http://www.ruby-doc.org/core-2.1.2/)
* [Sinatra](http://www.sinatrarb.com/)
* [RSpec](https://www.relishapp.com/rspec/rspec-core/v/2-99/docs/)
* [Thin](http://code.macournoyer.com/thin/)
* [Foundation](http://foundation.zurb.com/)
* [Sass](http://sass-lang.com/)
* [CoffeeScript](http://coffeescript.org/)
* [Assetpack](https://github.com/rstacruz/sinatra-assetpack)
* [DataObjects - mysql](https://github.com/datamapper/do)

Maintainers
-----------

* [Mary-Anne Cosgrove](https://github.com/macosgrove) (owner)
* [Steven Douglas](https://github.com/stevend)
* [Glenn Tweedie](https://github.com/nocache)

License
-------

Released under the [MIT license](https://github.com/envato/mandrill-merge/blob/master/LICENSE.txt)
