# create local group/user for tomcat

execute "create_tomcat_group" do
    command "lgroupadd -g #{node[:tomcat][:gid]} #{node[:tomcat][:group]}"
    only_if {File.readlines("/etc/group").grep(/#{node[:tomcat][:group]}/).empty?}
    action:run
end

execute "create_tomcat_user" do
    command "luseradd -d #{node[:tomcat][:homedir]} -g #{node[:tomcat][:group]} -s #{node[:tomcat][:shell]} -u #{node[:tomcat][:uid]} -k #{node[:tomcat][:skeldir]} -c '#{node[:tomcat][:comment]}' #{node[:tomcat][:user]}"
    only_if {File.readlines("/etc/passwd").grep(/#{node[:tomcat][:user]}/).empty?}
    action:run
end

# set perms on app dir, not homedir

execute "chown_tomcat_dir" do
    command "chown -R #{node[:tomcat][:user]}:#{node[:tomcat][:group]} #{node[:tomcat][:dir]}"
    action :run
    only_if {Dir.exists?("#{node[:tomcat][:dir]}")}
end

