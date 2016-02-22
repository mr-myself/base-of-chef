cookbook_file "/etc/logrotate.d/#{node['app']}" do
  source "logrotate"
  owner "root"
  group "root"
  mode "0644"
end
