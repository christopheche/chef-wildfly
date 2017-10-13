# encoding: UTF-8
# rubocop:disable LineLength
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

# => oracledb Database Configuration
# => oracledb ConnectorJ
default['wildfly']['oracledb']['enabled'] = true
default['wildfly']['oracledb']['url'] = http://download.oracle.com/otn/utilities_drivers/jdbc/121020/ojdbc7.jar'
default['wildfly']['oracledb']['checksum'] = '7c9b5984b2c1e32e7c8cf3331df77f31e89e24c2'

# => oracledb ConnectorJ JDBC Module Name
default['wildfly']['oracledb']['mod_name'] = 'com.oracle'
# => oracledb ConnectorJ Module Dependencies
default['wildfly']['oracledb']['mod_deps'] = ['javax.api', 'javax.transaction.api']
