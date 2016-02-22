yum_package "yum-fastestmirror" do
  action :install
end

execute "yum-update" do
  command "yum -y update"
  action :run
end

# add the EPEL repo
yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  fastestmirror_enabled true
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  action :create
end

# add the Remi repo
yum_repository 'remi' do
  description 'Les RPM de Remi - Repository'
  baseurl 'http://rpms.famillecollet.com/enterprise/6/remi/x86_64/'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  fastestmirror_enabled true
  action :create
end

%w(gcc gcc-c++ make git openssl-devel vim zlib-devel libxml2-devel libxslt-devel readline-devel libyaml-devel libffi-devel nkf tk tcl tk-devel).each do |pkg|
  package pkg do
    action :install
  end
end

service 'iptables' do
  action [:disable, :stop]
end

# set JST local time
template "/etc/sysconfig/clock" do
  source "clock"
end

bash "refrection clock" do
  code "source /etc/sysconfig/clock"
end

execute "set Tokyo Time" do
  command "cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime"
end

# selinux無効化
template "/etc/selinux/config" do
  source "selinux"
end

user "#{node['user']['name']}" do
  comment "#{node['user']['name']}"
  home "/home/#{node['user']['name']}"
  shell "/bin/bash"
  password nil
  supports :manage_home => true
  action :create
end

group "#{node['user']['group']}" do
  group_name "#{node['user']['group']}"
  action [:create]
end

directory "/home/#{node['user']['name']}/.ssh" do
  mode "0755"
  owner "#{node['user']['name']}"
  group "#{node['user']['name']}"
  action :create
end

bash ".ssh/authorized_keys" do
  code "touch /home/#{node['user']['name']}/.ssh/authorized_keys"
  #mode "0600"
end

directory "/var/cache/nginx" do
  mode "0755"
  action :create
end
