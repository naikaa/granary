#
# Cookbook Name:: Tomcat
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.



default["tomcat"]["port"] = 8080
default["tomcat"]["ssl_port"] = 8443
default["tomcat"]["shutdown_port"] = 8005
default["tomcat"]["ajp_port"] = 8009
default["tomcat"]["java_options"] = "-Xmx128M -Djava.awt.headless=true"
default["tomcat"]["use_security_manager"] = false
default["tomcat"]["user"] = "webadm"
default["tomcat"]["uid"] = "5174"
default["tomcat"]["group"] = "webadm"
default["tomcat"]["gid"] = "880"
default["tomcat"]["shell"] = "/bin/false"
default["tomcat"]["skeldir"] = "/etc/skel"
default["tomcat"]["comment"] = "App Id"
default["tomcat"]["homedir"] = "/home/apps/#{node[:tomcat][:user]}"
default["tomcat"]["context_dir"] = "#{tomcat["config_dir"]}/Catalina/localhost"
default['tomcat']['dir'] = "/opt/tomcat"
default['tomcat']['version'] = '7'
default['tomcat']['7']['installer'] = 'apache-tomcat-7.0.39.tar'
default['tomcat']['7']['dir'] = 'apache-tomcat-7.0.39'
