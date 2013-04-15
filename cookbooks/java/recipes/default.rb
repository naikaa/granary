#
# Cookbook Name:: MacysJava
# Recipe:: sun.rb
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

jdk_version = node['java']['jdk_version']
java_dir = node['java']['dir']

#convert version number to a string if it isn't already
if jdk_version.instance_of? Fixnum
  jdk_version = jdk_version.to_s
end

case jdk_version
when "6"
  jdk_installer = node['java']['jdk']['6']['installer']
  jdk_dir = node['java']['jdk']['6']['dir']
  jdk_checksum = node['java']['jdk']['6']['checksum']
when "7"
  jdk_installer = node['java']['jdk']['7']['installer']
  jdk_dir = node['java']['jdk']['7']['dir']
  jdk_checksum = node['java']['jdk']['7']['checksum']
end

unless (FileTest.directory?("#{java_dir}/#{jdk_dir}"))
  directory "#{node['java']['dir']}" do
    owner "root"
    group "root"
    mode "755"
  end

  cookbook_file "#{java_dir}/#{jdk_installer}" do
    source "#{jdk_installer}"
    mode "0644"
#    checksum jdk_checksum
  end

  case jdk_version
  when "6"
    bash "extract_jdk" do
      cwd "#{java_dir}"
      code "/bin/bash #{jdk_installer} -noregister"
    end
  when "7"
    bash "untar_jdk" do
      cwd "#{java_dir}"
      code "/bin/gzip -d #{jdk_installer}"
    end
  end
end  

link "#{java_dir}/default" do
  to "#{java_dir}/#{jdk_dir}"
  not_if { FileTest.symlink?("#{java_dir}/default")}
end

link "/usr/bin/java" do
  to "#{java_dir}/default/bin/java"
  not_if { FileTest.symlink?("/usr/bin/java")}
end    
