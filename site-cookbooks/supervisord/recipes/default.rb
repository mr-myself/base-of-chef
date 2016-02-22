%w(/var/log/supervisor /etc/supervisord.d).each do |dir|
  bash "create dir" do
    code <<-EOH
      mkdir #{dir}
    EOH
    not_if { File.exist?("#{dir}") }
  end
end

cookbook_file "/etc/supervisord.conf" do
  source "supervisord.conf"
  owner "root"
  group "root"
  mode "0644"
  not_if { File.exist?("/etc/supervisord.conf") }
end

cookbook_file "/etc/init/supervisord.conf" do
  source "init_supervisord.conf"
  owner "root"
  group "root"
  mode "0644"
  not_if { File.exist?("/etc/init/supervisord.conf") }
end

yum_package "python-setuptools" do
  action :install
end

bash "install supervisord" do
  code <<-EOH
    easy_install pip
    pip install supervisor --pre
  EOH
end

bash "start" do
  user 'root'
  code <<-EOH
    initctl start supervisord
    supervisorctl start all
  EOH
end
