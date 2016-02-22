template "/home/#{node['user']['name']}/.bash_profile" do
  owner "#{node['user']['name']}"
  group "#{node['user']['group']}"
  source "bash_profile.erb"
  mode 0644
end

group "rbenv" do
  action :create
  members "#{node['user']['group']}"
  append true
end

git "/home/#{node['user']['name']}/.rbenv" do
  repository "git://github.com/sstephenson/rbenv.git"
  reference "master"
  action :sync
  user "#{node['user']['name']}"
  group "#{node['user']['group']}"
end

directory "/home/#{node['user']['name']}/.rbenv/plugins" do
  owner "#{node['user']['name']}"
  group "#{node['user']['group']}"
  mode "0755"
  action :create
end

template "/home/#{node['user']['name']}/rbenv.sh" do
  owner "#{node['user']['name']}"
  group "#{node['user']['group']}"
  source "rbenv.sh.erb"
  mode 0644
end

git "/home/#{node['user']['name']}/.rbenv/plugins/ruby-build" do
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  user "#{node['user']['name']}"
  group "rbenv"
  action :sync
end

execute "ruby install" do
  not_if "source /home/#{node['user']['name']}/rbenv.sh; rbenv versions | grep #{node['ruby']['version']}"
  command "source /home/#{node['user']['name']}/rbenv.sh; rbenv install #{node['ruby']['version']}"
  action :run
end

execute "ruby change" do
  user "#{node['user']['name']}"
  command "source /home/#{node['user']['name']}/rbenv.sh; rbenv global #{node['ruby']['version']};rbenv rehash"
  action :run
end

gem_package "bundler" do
  action :install
end
