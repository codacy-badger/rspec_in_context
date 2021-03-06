# RspecInContext

[![Gem Version](https://badge.fury.io/rb/rspec_in_context.svg)](https://badge.fury.io/rb/rspec_in_context)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/7ee82740e840412b864574851aa44f16)](https://www.codacy.com/project/denis-pasin/rspec_in_context/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=denispasin/rspec_in_context&amp;utm_campaign=Badge_Grade_Dashboard)


This gem is here to help you write better shared_examples in Rspec.

Ever been bothered by the fact that they don't really behave like methods and that you can't pass it a block ? There you go: `rspec_in_context`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_in_context'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_in_context

## Usage

### Add this into Rspec

You must require the gem on top of your spec_helper:
```ruby
require 'rspec_in_context'
```

Then include it into Rspec:
```ruby
RSpec.configure do |config|
  [...]
  
  config.include RspecInContext
end
```

### Define a new in_context

You can define in_context block that are reusable almost anywhere.
They completely look like normal Rspec.

##### Inside a Rspec block (scoped)

```ruby
# A in_context can be named with a symbol or a string
define_context :context_name do
  it 'works' do
    expect(true).to be_truthy
  end
end
```

Those in_context will be scoped to their current `describe`/`context` block.

##### Outside a Rspec block (globally)

Outside of a test you have to use `RSpec.define_context`. Those in_context will be defined globally in your tests.


### Use the context

Anywhere in your test description, use a `in_context` block to use a predefined in_context.

**Important**: in_context are scoped to their current `describe`/`context` block. If you need globally defined context see `RSpec.define_context`

```ruby
# A in_context can be named with a symbol or a string
RSpec.define_context :context_name do
  it 'works' do
    expect(true).to be_truthy
  end
end

[...]
Rspec.describe MyClass do
  in_context :context_name # => will execute the 'it works' test here
end
```

### Things to know

#### Inside block execution

* You can chose exactly where your inside test will be used:
By using `execute_tests` in your define context, the test passed when you *use* the context will be executed here

```ruby
define_context :context_name do
  it 'works' do
    expect(true).to be_truthy
  end
  context "in this context pomme exists" do
    let(:pomme) { "abcd" }
    
    execute_tests
  end
end

[...]

in_context :context_name do
  it 'will be executed at execute_tests place' do
    expect(pomme).to eq("abcd") # => true
  end
end
```

* You can add variable instantiation relative to your test where you exactly want:

`instanciate_context` is an alias of `execute_tests` so you can't use both.
But it let you describe what the block will do better.

#### Variable usage

* You can use variable in the in_context definition

```ruby
define_context :context_name do |name|
  it 'works' do
    expect(true).to be_truthy
  end
  context "in this context #{name} exists" do
    let(name) { "abcd" }
    
    execute_tests
  end
end

[...]

in_context :context_name, :poire do
  it 'the right variable will exists' do
    expect(poire).to eq("abcd") # => true
  end
end
```

#### Scoping

* In_contexts can be scope inside one another

```ruby
define_context :context_name do |name|
  it 'works' do
    expect(true).to be_truthy
  end
  context "in this context #{name} exists" do
    let(name) { "abcd" }
    
    execute_tests
  end
end

define_context "second in_context" do
  context 'and tree also' do
    let(:tree) { 'abcd' }

    it 'will scope correctly' do
      expect(tree).to eq(poire)
    end
  end
end

[...]

in_context :context_name, :poire do
  it 'the right variable will exists' do
    expect(poire).to eq("abcd") # => true
  end

  in_context "second in_context" # => will work
end
```

* in_context are bound to their current scope

#### Namespacing

* You can add a namespace to a in_context definition

```ruby
define_context "this is a namespaced context", namespace: "namespace name"
```
Or
```ruby
define_context "this is a namespaced context", ns: "namespace name"
```
Or
```ruby
RSpec.define_context "this is a namespaced context", ns: "namespace name"
```

* When you want to use a namespaced in_context, you have two choice:

Ignore any namespace and it will try to find a corresponding in_context in any_namespace (the ones defined without namespace have the priority);
```ruby
define_context "namespaced context", ns: "namespace name" do
  [...]
end

in_context "namespaced context"
```

Pass a namespace and it will look only in this context.
```ruby
define_context "namespaced context", ns: "namespace name" do
  [...]
end

in_context "namespaced context", namespace: "namespace name"
in_context "namespaced context", ns: "namespace name"
```

## Development


After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

After setuping the repo, you should run `overcommit --install` to install the different hooks.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/denispasin/rspec_in_context.
