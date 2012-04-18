user 'my_user'
hosts 'stage.example.com'
repository 'git@git.bar.co.uk:whatever.git'
path "/fullpath/to/folder"

#ruby_bin_path "/fullpath/to/ruby/bin/folder"

set :my_value => 'something'

env :production do
  hosts 'production1.example.com', 'production2.example.com'
  set :my_value => 'something_else'

  action :restart do
    run 'touch tmp/restert.txt'
  end
end

action :restart do
  run 'touch tmp/restert.txt'
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