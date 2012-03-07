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

action :some_global_action do
  run 'touch test.txt'
end

strategy :update, 'Update the code base on the server' do
  prerequisite :setup

  actions :update_repository, :install_gems
  call :restart
end

strategy :deploy, 'Full deployment to the server' do
  call :update
  actions :migrate_database
  call :restart
end

strategy :restart, 'Restart application' do
  action :restart do
    run 'touch tmp/restert.txt'
  end
end