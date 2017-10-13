# encoding: UTF-8
# rubocop:disable LineLength
#
# Cookbook Name:: wildfly
# Recipe:: mysql_connector
#
# Copyright (C) 2014 Brian Dwyer - Intelligent Digital Services
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# => Make MySQL Connector/J Information Retrievable
node.default['wildfly']['oracledb']['version'] = ::File.basename(node['wildfly']['oracledb']['url'], '.jar')
node.default['wildfly']['oracledb']['jar'] = "#{node['wildfly']['mysql']['version']}-bin.jar"

# => Shorten Hashes
wildfly = node['wildfly']
mysql = node['wildfly']['oracledb']

# => Shorten Connector/J Directory Name
connectorj_dir = ::File.join(wildfly['base'], 'modules', 'system', 'layers', 'base', 'com', 'oracle', 'main')

# => Create oracledb Connector/J Directory
directory connectorj_dir do
  owner wildfly['user']
  group wildfly['group']
  mode '0755'
  recursive true
end

# => Download MySQL Connector/J Tarball
remote_file "#{Chef::Config[:file_cache_path]}/#{oracledb['version']}.jar" do
  source mysql['url']
  checksum mysql['checksum']
  action :create
  notifies :run, 'bash[Extract ConnectorJ]', :immediately
end

# => Extract MySQL Connector/J
bash 'Extract ConnectorJ' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  chown #{wildfly['user']}:#{wildfly['group']} -R #{connectorj_dir}/../
  EOF
  not_if { ::File.exist?(::File.join(connectorj_dir, oracledb['jar'])) }
end

# => Configure MySQL Connector/J Module
template ::File.join(connectorj_dir, 'module.xml') do
  source 'module.xml.erb'
  user wildfly['user']
  group wildfly['group']
  mode '0644'
  variables(
    module_name: oracledb['mod_name'],
    resource_path: oracledb['jar'],
    module_dependencies: oracledb['mod_deps']
  )
  action :create
  notifies :restart, "service[#{wildfly['service']}]", :immediately
end
