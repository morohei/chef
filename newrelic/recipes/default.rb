#
# Cookbook Name:: newrelic
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if node["hostname"] == node["newrelic"]["hostname"]

 # rpm
 remote_file "#{Chef::Config[:file_cache_path]}/newrelic-repo-5-3.noarch.rpm" do
    source "http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm"
    not_if "rpm -qa | grep -q '^newrelic-repo'"
    action :create
    notifies :install, "rpm_package[newrelic-agent]", :immediately
 end

 rpm_package "newrelic-agent" do
    source "#{Chef::Config[:file_cache_path]}/newrelic-repo-5-3.noarch.rpm"
    action :nothing
 end

  # yum
  yum_package "newrelic-sysmond" do
    action :install
  end

  # newrelic install
  bash 'license-install' do
    command 'nrsysmond-config --set license_key= node[newrelic][license]'
  end

  service "newrelic-sysmond" do
     action [:enable, :start] 
  end


end
