#
# Cookbook Name:: jboss
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#create jboss user


execute "create_group" do
    command "lgroupadd -g #{node[:jboss][:gid]} #{node[:jboss][:group]}"
    not_if do
       Dir.exists?("#{node[:jboss][:homedir]}")
    end
    action:run
end

execute "create_user" do
    command "luseradd -d #{node[:jboss][:homedir]} -g #{node[:jboss][:group]} -s #{node[:jboss][:shell]} -u #{node[:jboss][:uid]} -k #{node[:jboss][:skeldir]} -c '#{node[:jboss][:comment]}' #{node[:jboss][:owner]}"
    not_if do
       Dir.exists?("#{node[:jboss][:homedir]}")
    end
    action:run
end


#copy the jboss source files
remote_file "#{node[:jboss][:install_directory]}/#{node[:jboss][:sourceFile]}.zip" do
        source "#{node['jboss']['sourceURL']}"
        owner "#{node['jboss']['owner']}"
        group "#{node['jboss']['group']}"
        mode    "755"
  backup 0
not_if { File.exists?("#{node[:jboss][:install_directory]}/#{node[:jboss][:sourceFile]}.zip")}
end


###############################################
# install binary then delete tar file
###############################################

# Untar unzip jboss binary

bash "unzip_jboss" do
        cwd "#{node[:jboss][:install_directory]}"
        code "unzip #{node[:jboss][:install_directory]}/#{node[:jboss][:sourceFile]} > /dev/null"
not_if {Dir.exists?("#{node[:jboss][:install_directory]}/#{node[:jboss][:sourceFile]}")}
end

# create soft link
bash "createsoftlink_jboss" do
        cwd "#{node[:jboss][:install_directory]}"
        code "ln -s #{node[:jboss][:install_directory]}/#{node[:jboss][:sourceFile]} #{node[:jboss][:install_directory]}/jboss"
not_if { FileTest.symlink?("#{node[:jboss][:install_directory]}/jboss")}
end

# Delete Jboss zip file

file "#{node[:jboss][:install_directory]}/#{node[:jboss][:sourceFile]}.zip" do
  action :delete
end


#add the server init file

cookbook_file "#{node[:jboss][:install_directory]}/jboss/bin/#{node['jboss']['init']}" do
        source "#{node['jboss']['init']}"
        owner "#{node['jboss']['owner']}"
        group "#{node['jboss']['group']}"
        mode    "755"
  backup 0
end

#update the bindings file so jboss starts on 8180

cookbook_file "#{node[:jboss][:install_directory]}/jboss/server/#{node['jboss']['default_bindings']}" do
        source "#{node['jboss']['bindings']}"
        owner "#{node['jboss']['owner']}"
        group "#{node['jboss']['group']}"
        mode    "755"
  backup 0
end


# chown to jboss
bash "chown_jboss" do
        cwd "#{node[:jboss][:install_directory]}"
        code "chown -R jboss:jboss #{node[:jboss][:install_directory]}/jboss*"
end


link "/etc/init.d/jboss" do
  to "#{node[:jboss][:install_directory]}/jboss/bin/#{node[:jboss][:init]}"
  not_if { FileTest.symlink?("/etc/init.d/jboss")}
end

