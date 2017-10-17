# encoding: UTF-8
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

# => Oracle Datasource Definitions
# => Stored as an array of hashes

default['wildfly']['oracle']['jndi']['datasources'] = [
  {
    jndi_name: 'java:/jdbc/service/SSM',
    pool_name: 'SSM',
    server: 'orapreclu01-scan.srv.infragaz.com',
    port: '1521',
    db_name: 'SSMPRE',
    db_user: 'APP_SSM',
    db_pass: 'APP_SSM',
    pool_min: '10',
    pool_max: '200'
  },
  {
    jndi_name: 'java:/jdbc/service/QUARTZ',
    pool_name: 'QUARTZ',
    server: 'orapreclu01-scan.srv.infragaz.com',
    port: '1521',
    db_name: 'SSMPRE',
    db_user: 'APP_SSM',
    db_pass: 'APP_SSM',
    pool_min: '10',
    pool_max: '60'
  }
  ,
  {
    jndi_name: 'java:/jdbc/service/CDM',
    pool_name: 'dataSourceCDM',
    server: 'orapreclu01-scan.srv.infragaz.com',
    port: '1521',
    db_name: 'CDMPRE',
    db_user: 'LSCDM',
    db_pass: 'LSCDM',
    pool_min: '0',
    pool_max: '10'
  }
]
