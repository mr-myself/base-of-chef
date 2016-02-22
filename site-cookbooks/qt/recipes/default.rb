cookbook_file "/home/#{node['user']['name']}/qt-everywhere-opensource-src-5.2.1.tar.gz" do
  source 'qt-everywhere-opensource-src-5.2.1.tar.gz'
  not_if { File.exist?("/home/#{node['user']['name']}/qt-everywhere-opensource-src-5.2.1.tar.gz") }
end

execute 'tar zxvf' do
  user "#{node['user']['name']}"
  command "cd /home/#{node['user']['name']} && tar zxvf qt-everywhere-opensource-src-5.2.1.tar.gz"
end

execute 'configure' do
  command "cd /home/#{node['user']['name']}/qt-everywhere-opensource-src-5.2.1 && ./configure"
  # you should answer 2 questions -> 1. o ,  2. yes
end

# ２時間位かかる
execute 'gmake' do
  command 'gmake'
end

execute 'make_install' do
  user 'root'
  command 'gmake install'
end
