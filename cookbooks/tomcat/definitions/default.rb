#
# Cookbook Name:: gapTomcat
# Recipe:: default
#

define :java_app, :cookbook => nil , :javaapp_home => "/opt/apps", :ssl_source => nil, :ssl_key_dir => nil do

  name = params[:name]
  javaapp_home = params[:javaapp_home]
  ssl_source = params[:ssl_source]
  ssl_key_dir = params[:ssl_key_dir]
  catalina_base = "#{javaapp_home}/#{name}"

  link "/opt/tomcat/#{name}" do
    to "/opt/tomcat/#{node['tomcat'][node['tomcat']['version']]['dir']}/"
  end

  link "/usr/java/#{name}" do
    to "/usr/java/#{node['java']['jdk'][node['java']['jdk_version']]['dir']}/"
  end

  dirs = [javaapp_home, catalina_base, "#{catalina_base}/bin", "#{catalina_base}/conf", "#{catalina_base}/logs", "#{catalina_base}/temp", "#{catalina_base}/webapps", "#{catalina_base}/work"]

  dirs.each do |dir| 
    directory dir do
      owner "#{node["tomcat"]["user"]}"
      group "#{node["tomcat"]["group"]}"
      mode "0755"
      action :create
    end
  end

  cookbook_file "#{ssl_key_dir}" do
    source ssl_source
    cookbook params[:cookbook] if params[:cookbook]
    owner node["tomcat"]["user"]
    group node["tomcat"]["group"]
    mode "644"
    notifies :restart, "service[#{name}]"
    not_if { !(ssl_source && ssl_key_dir) }
  end 

  template "#{catalina_base}/conf/server.xml" do
    source "server.xml.erb"
    cookbook params[:cookbook] if params[:cookbook]
    owner "#{node["tomcat"]["user"]}"
    group "#{node["tomcat"]["group"]}"
    mode "0644"
    notifies :restart, "service[#{name}]"
  end
  
  template "#{catalina_base}/conf/web.xml" do
    source "web.xml.erb"
    cookbook params[:cookbook] if params[:cookbook]
    owner "#{node["tomcat"]["user"]}"
    group "#{node["tomcat"]["group"]}"
    mode "0644"
    notifies :restart, "service[#{name}]"
  end
  
  files = ["catalina.policy", "catalina.properties", "context.xml", "logging.properties", "tomcat-users.xml"] 
  files.each do |file|
    cookbook_file "#{catalina_base}/conf/#{file}" do
      source "#{file}"      
      cookbook "gapTomcat"
      owner "#{node["tomcat"]["user"]}"
      group "#{node["tomcat"]["group"]}"
      mode "0644"
    end
  end
  
  template "#{catalina_base}/conf/default_#{name}.conf" do
    source "default_tomcat6.erb"
    if params[:cookbook]
      cookbook params[:cookbook]
    else
      cookbook 'gapTomcat'
    end
    owner "#{node["tomcat"]["user"]}"
    group "#{node["tomcat"]["group"]}"
    mode "0644"
    notifies :restart, "service[#{name}]"
  end
  
  template "#{catalina_base}/bin/startup.sh" do
    source "startup.sh.erb"
    cookbook "gapTomcat"
    owner "#{node["tomcat"]["user"]}"
    group "#{node["tomcat"]["group"]}"
    mode "0755"
    variables(
    :app_name => name
    )
  end
  
  template "#{catalina_base}/bin/shutdown.sh" do
    source "shutdown.sh.erb"
    cookbook "gapTomcat"
    owner "#{node["tomcat"]["user"]}"
    group "#{node["tomcat"]["group"]}"
    mode "0755"
    variables(
    :app_name => name
    )
  end
  
  template "/etc/init.d/#{name}" do
    source "tomcat.init.erb"
    cookbook "gapTomcat"
    owner "root"
    group "root"
    mode "0755"
    variables(
    :app_name => name
    )
    notifies :restart, "service[#{name}]"
  end

# Add in the jcd.properties file for this app  
  template "#{catalina_base}/conf/jcd.properties" do
    source "jcd.properties.erb"
    cookbook "gapTomcat"
    owner "#{node["tomcat"]["user"]}"
    group "#{node["tomcat"]["group"]}"
    mode "0644"
    variables(
    :app_name => name,
    :host_name => node['hostname']
    )
    notifies :restart, "service[#{name}]"
  end
  
  service "#{name}" do
    service_name "#{name}"
    action [:start, :enable]
    supports :restart => true, :stop => true
  end
  
#  gapNagios_nrpecheck "check_procs_tomcat" do
#    command "#{node['nagios']['plugin_dir']}/check_procs"
#    parameters "-a '/usr/java/#{name}/bin/java'"
#    warning_condition node['nagios']['checks']['procs_tomcat']['warning']
#    critical_condition node['nagios']['checks']['procs_tomcat']['critical']
#    action :add
#  end
  
#  gapNagios_nrpecheck "check_tomcat_port" do
#    command "#{node['nagios']['plugin_dir']}/check_http"
#    parameters "-I 127.0.0.1 -H #{node['fqdn']} -u /sample -p #{node['tomcat']['port']}"
#    warning_condition node['nagios']['checks']['tomcat_port']['warning']
#    critical_condition node['nagios']['checks']['tomcat_port']['critical']
#    action :add
#  end
end  
