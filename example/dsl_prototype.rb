config do
  user 'my_user'
  hosts 'stage.example.com'
  repository 'git@git.bar.co.uk:whatever.git'
  path "/path/to/data/folder"

  env :production do
    hosts 'production1.example.com', 'production2.example.com'
  end
end

set :my_value => 'something'

requisite :bootstrap, :user => 'admin' do
  run "adduser #{my_value}"
end

requisite :setup, :pre => :bootstrap do
  #something
end

prerequisite :setup, :for => :update

action :restart do
  run 'touch tmp/restert.txt'
end

strategy :update do
  desc 'Update the code base on the server'
  prerequisite :setup

  actions :update_repository, :install_gems
  call :restart
end

strategy :deploy do
  desc 'Full deployment to the server'

  call :update
  actions :migrate_database
  call :restart
end

strategy :restart do
  desc 'Restart application'

  action :restart do
    run 'touch tmp/restert.txt'
  end
end