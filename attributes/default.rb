#
# Cookbook Name:: nsd3
# Attributes:: nsd3
#
# Copyright 2012, Koichi Watanabe
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

## General
default[:nsd3][:user] = "nsd"
default[:nsd3][:group] = "nsd"

## Install Method (source or package)
default[:nsd3][:install_method] = "source"

## Source Install
default[:nsd3][:version] = "3.2.14"
default[:nsd3][:url] = "http://www.nlnetlabs.nl/downloads/nsd/nsd-#{node[:nsd3][:version]}.tar.gz"

default[:nsd3][:dir] = "/usr/local/nsd"
default[:nsd3][:install_path] = "/usr/local/nsd-#{node[:nsd3][:version]}"
default[:nsd3][:openssl_dir] = "/usr"

#default[:nsd3][:cflags] = "-O2"
#default[:nsd3][:ld_library_path] = "/lib:/usr/lib:/usr/local/lib"
#default[:nsd3][:library_path] = "/lib:/usr/lib:/usr/local/lib"
default[:nsd3][:configure_flags] = [
  "--prefix=#{node[:nsd3][:install_path]}",
  "--with-ssl=#{node[:nsd3][:openssl_dir]}",
  "--with-user=#{node[:nsd3][:user]}"
]

## Configuration
default[:nsd3][:conf][:database] = "#{node[:nsd3][:dir]}/var/db/nsd/nsd.db"
default[:nsd3][:conf][:logfile] = "#{node[:nsd3][:dir]}/var/log/nsd.log"
default[:nsd3][:conf][:pidfile] = "#{node[:nsd3][:dir]}/var/db/nsd/nsd.pid"
default[:nsd3][:conf][:statfile] = "#{node[:nsd3][:dir]}/var/log/nsd.stats"
default[:nsd3][:conf][:zonesdir] = "#{node[:nsd3][:dir]}/etc/nsd"
default[:nsd3][:conf][:difffile] = "#{node[:nsd3][:dir]}/var/db/nsd/ixfr.db"
default[:nsd3][:conf][:xfrdfile] = "#{node[:nsd3][:dir]}/var/db/nsd/xfrd.state"
