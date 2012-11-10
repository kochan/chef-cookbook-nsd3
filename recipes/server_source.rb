#
# Cookbook Name:: nsd3
# Recipe:: default
#
# Copyright 2012, Koichi Watanabe
#
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
#

include_recipe "build-essential"
include_recipe "openssl"

packages = []

packages.each do |p|
  package p
end

bash "compile_nsd3_source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxf nsd-#{node[:nsd3][:version]}.tar.gz
    (cd nsd-#{node[:nsd3][:version]} && ./configure #{node[:nsd3][:configure_flags].join(" ")})
    (cd nsd-#{node[:nsd3][:version]} && make && make install)
  EOH
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/nsd-#{node[:nsd3][:version]}.tar.gz" do
  source "#{node[:nsd3][:url]}"
  action :create_if_missing
  not_if "test -d #{node[:nsd3][:install_path]}"
  notifies :run, "bash[compile_nsd3_source]", :immediately
end

%w{var/log var/run var/db/nsd}.each do |dir|
  directory "#{node[:nsd3][:install_path]}/#{dir}" do
    mode "0775"
    owner node[:nsd3][:user]
    group node[:nsd3][:group]
    action :create
    recursive true
  end
end

link "#{node[:nsd3][:dir]}" do
  to "#{node[:nsd3][:install_path]}"
  action :create
end

template "/etc/init.d/nsd3" do
  source "nsd3.erb"
  mode "0755"
  action :create
end

service "nsd3" do
  supports :start => true, :stop => true, :restart => true, :reload => true, :notify => true, :upload => true
  action [ :enable ]
end

remote_directory "#{node[:nsd3][:install_path]}/etc/nsd/master" do
  source "master"
  files_owner node[:nsd3][:user]
  files_group node[:nsd3][:group]
  files_mode "0644"
  owner node[:nsd3][:user]
  group node[:nsd3][:group]
  mode "0755"
end

template "#{node[:nsd3][:install_path]}/etc/nsd/nsd.conf" do
  source "nsd.conf.erb"
  owner node[:nsd3][:user]
  group node[:nsd3][:group]
  mode "0600"
  action :create
  notifies :reload, "service[nsd3]", :immediately
  notifies :restart, "service[nsd3]", :immediately
end
