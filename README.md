# Trooper [![Build Status](https://secure.travis-ci.org/madwire/trooper.png?branch=master)](http://travis-ci.org/madwire/trooper)

Trooper is designed to give you the flexibility to deploy your code to any server in any way you like.
You design your deployment strategy to best fit your application and its needs. 
Trooper comes with some built in actions that you can use in your own strategies or come up with entirely new ones.

#### Please give me a try on your small project for now

We have been using earlier versions of trooper were I work for the best part of 2 years, 
but I re-wrote it for public release and so has lost a lot of its maturity.

## Installation

1. Super easy! `gem install trooper` or add it to your Gemfile `gem 'trooper'`
2. Pop into your terminal and run `=> trooper init`
3. Start building you deployment strategy :)

## Usage

`=> trooper deploy -e staging` or `=> trooper update`

#### Define your own strategies and actions

```ruby
action :restart_server, 'Restarting the server' do
  run 'touch tmp/restart.txt'
  run "echo 'Restarted'"
end

strategy :restart, 'Restart application' do
  actions :restart_server
end

strategy :update, 'Update the code base on the server' do
  actions :update_repository, :install_gems
  call :restart # call another strategy
end
```

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

action :restart do
  run 'touch tmp/restert.txt'
  run "echo 'Restarted'"
end

strategy :update, 'Update the code base on the server' do
  actions :update_repository, :install_gems
  call :restart
end

strategy :deploy, 'Full deployment to the server' do
  call :update
  actions :migrate_database
  call :restart
end

strategy :restart, 'Restart application' do
  actions :restart
end
```

## LICENSE

Copyright 2011 Richard Adams

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