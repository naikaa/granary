#
# Cookbook Name:: stellaApp
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'jboss'

#######################################
### Deploy Stella code 
#######################################
remote_file "#{node[:jboss][:app_home]}/stella.war" do
        source "#{node['jboss']['war']}"
        owner "#{node['jboss']['owner']}"
        group "#{node['jboss']['group']}"
        mode    "755"
  backup 0
end
