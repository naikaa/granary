#
# Cookbook Name:: Tomcat
# Recipe:: server
#

include_recipe "java"

tomcat_user = node['tomcat']['user']
tomcat_group = node['tomcat']['group']
tomcat_version = node['tomcat']['version']
tomcat_base = node['tomcat']['dir']

#convert version number to a string if it isn't already
if tomcat_version.instance_of? Fixnum
  tomcat_version = tomcat_version.to_s
end

case tomcat_version
when "6"
  tomcat_installer = node['tomcat']['6']['installer']
  tomcat_dir = node['tomcat']['6']['dir']
  tomcat_checksum = node['tomcat']['6']['checksum']
when "7"
  tomcat_installer = node['tomcat']['7']['installer']
  tomcat_dir = node['tomcat']['7']['dir']
  tomcat_checksum = node['tomcat']['7']['checksum']
end

unless (FileTest.directory?("#{tomcat_base}/#{tomcat_dir}"))
  directory "#{tomcat_base}" do
    owner "#{tomcat_user}"
    group "#{tomcat_group}" 
    mode "755"
  end

  cookbook_file "#{tomcat_base}/#{tomcat_installer}" do
    source "#{tomcat_installer}"
    mode "0644"
#    checksum tomcat_checksum
  end

  bash "untar_tomcat" do
    cwd "#{tomcat_base}"
    code "/bin/tar -xzf #{tomcat_installer} > /dev/null"
  end
end  
