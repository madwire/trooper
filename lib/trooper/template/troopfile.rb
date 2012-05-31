#Basic settings
user 'my_user'
hosts 'stage.example.com'
path "/fullpath/to/folder"
repository 'git@git.bar.co.uk:whatever.git'
# ruby_bin_path "/fullpath/to/ruby/bin/folder" # Define if you have issues with gems

# set :my_value => 'something' # Setting a custom value

# Set environment specific settings and or actions   
# env :stage do
#   hosts 'stage.example.com', 'stage.example.com'
#   set :my_value => 'something_else'

#   action :my_action do
#     #some action
#   end
# end

# action :my_action do
#   #some action
# end

strategy :setup, 'Setting up Application on the Server' do
  actions :setup_trooper, :clone_repository, :setup_database
end

strategy :update, 'Update the code base on the server' do
  prerequisites :setup
  actions :update_repository, :install_gems
  call :restart
end

strategy :deploy, 'Full deployment to the server' do
  prerequisites :setup
  call :update
  actions :migrate_database
  call :restart
end

strategy :restart, 'Restart application' do
  actions :restart
end