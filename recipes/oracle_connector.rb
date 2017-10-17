# encoding: UTF-8
# rubocop:disable LineLength
#
# Cookbook Name:: wildfly
# Recipe:: Oracle_connector
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

# => Make Oracle Connector/J Information Retrievable
node.default['wildfly']['oracle']['version'] = ::File.basename(node['wildfly']['oracle']['url'], '.jar')
node.default['wildfly']['oracle']['jar'] = "#{node['wildfly']['oracle']['version']}-bin.jar"

# => Shorten Hashes
wildfly = node['wildfly']
Oracle = node['wildfly']['oracle']

# => Shorten Connector/J Directory Name
connectorj_dir = ::File.join(wildfly['base'], 'modules', 'system', 'layers', 'base', 'com', 'oracle', 'main')

# => Create oracle Connector/J Directory
directory connectorj_dir do
  owner wildfly['user']
  group wildfly['group']
  mode '0755'
  recursive true
end

# => Download Oracle Connector/J Tarball
remote_file "#{Chef::Config[:file_cache_path]}/#{oracle['version']}.jar" do
  source Oracle['url']
  checksum Oracle['checksum']
  action :create
  notifies :run, 'bash[Extract ConnectorJ]', :immediately
end

# => Extract Oracle Connector/J
bash 'Extract ConnectorJ' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  chown #{wildfly['user']}:#{wildfly['group']} -R #{connectorj_dir}/../
  EOF
  not_if { ::File.exist?(::File.join(connectorj_dir, oracle['jar'])) }
end

# => Configure Oracle Connector/J Module
template ::File.join(connectorj_dir, 'module.xml') do
  source 'module.xml.erb'
  user wildfly['user']
  group wildfly['group']
  mode '0644'
  variables(
    module_name: oracle['mod_name'],
    resource_path: oracle['jar'],
    module_dependencies: oracle['mod_deps']
  )
  action :create
  notifies :restart, "service[#{wildfly['service']}]", :immediately
end