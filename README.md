# Trooper [![Build Status](https://secure.travis-ci.org/madwire/trooper.png?branch=master)](http://travis-ci.org/madwire/trooper) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/madwire/trooper)

Trooper is designed to give you the flexibility to deploy your code to any server in any way you like.
You design your deployment strategy to best fit your application and its needs. 
Trooper comes with some built in actions that you can use in your own strategies or come up with entirely new ones.

## Installation

1. Super easy! `gem install trooper` or add it to your Gemfile `gem "trooper", "~> 0.6.1"`
2. Pop into your terminal and run `=> trooper init`
3. Start building you deployment strategy :)

## Usage

`=> trooper deploy -e stage` or `=> trooper update`

#### Action

An Action is a set of commands to be run in sequence, they should be small units of work. Trooper 
comes with some build in actions but you can of course overwrite them or ignore all together. 
Actions can also be run locally by adding the local: true option

```ruby
action :migrate_database, 'Migrating database' do
  cd application_path
  rake "db:migrate RAILS_ENV=#{environment}"
end

action :precompile_assets, 'Precompile assets', local: true do
  run 'do_stuff'
  rake "assets:precompile"
end
```

#### Strategy

A Strategy is collection of actions to be executed in sequence, A Strategy can call other
strategies and have prerequisites.

```ruby
strategy :my_strategy_name, "A Description of what the strategy does" do
  actions :clone_repository, :install_gems, :migrate_database
end
```

Once you've defined the your strategy you can call it e.g. `=> trooper my_strategy_name`

#### Prerequisite

A Prerequisite is a Strategy that can only run once per host


#### Example Troopfile

```ruby
user 'my_user'
hosts 'production1.example.com', 'production2.example.com'
repository 'git@git.foo.co.uk:bar.git'
path "/fullpath/to/data/folder"

set :my_value => 'something'

env :stage do
  hosts 'stage.example.com',
  set :my_value => 'something_else'

  action :restart do
    run 'touch tmp/restert.txt'
  end
end

action :restart, 'Restarting the server' do
  run 'touch tmp/restert.txt'
  run "echo 'Restarted'"
end

strategy :bootstrap, "Bootstrap application" do
  actions :setup_trooper, :clone_repository
end

strategy :update, 'Update the code base on the server' do
  prerequisites :bootstrap
  actions :update_repository, :install_gems
  call :restart
end

strategy :deploy, 'Full deployment to the server' do
  prerequisites :bootstrap
  call :update
  actions :migrate_database
  call :restart
end

strategy :restart, 'Restart application' do
  actions :restart
end
```

## LICENSE

Copyright 2012 Richard Adams

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 