# make sure we have java installed

node.default['java']['jdk_version'] = '8'

include_recipe 'java'

user 'chefed'

# put chefed in the group so we can make sure we don't remove it by managing cool_group
group 'cool_group' do
  members 'chefed'
  action :create
end

# Install Tomcat 8.0.47 to the default location
tomcat_install 'helloworld' do
  tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.47/bin/apache-tomcat-8.0.47.tar.gz'
  tomcat_user 'cool_user'
  tomcat_group 'cool_group'
end

# start the helloworld tomcat service using a non-standard pic location
tomcat_service 'helloworld' do
  action [:start, :enable]
  env_vars [{ 'CATALINA_BASE' => '/opt/tomcat_helloworld/' }, { 'CATALINA_PID' => '/opt/tomcat_helloworld/bin/non_standard_location.pid' }, { 'SOMETHING' => 'some_value' }]
  sensitive true
  tomcat_user 'cool_user'
  tomcat_group 'cool_group'
end
