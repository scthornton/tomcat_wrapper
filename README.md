# tomcat_wrapper

environment
Mac
Fusion
Hosted Chef 'https://api.chef.io:443/organizations/thornton'
Git https://github.com/scthornton
Bootstrap knife bootstrap 192.168.54.160 --ssh-user chef --sudo --identity-file /Users/sthornto/chef-repo/scthornton.pem  --node-name ubuntu1

https://downloads.chef.io/chef-dk/

# Install Git from:

https://git-scm.com/downloads/

# Install a Text Editor, I recommend Atom:

https://atom.io/

# Verify your SSH client

# Vagrant and VirtualBox - these are free utilities
# vagrant has a few different packaged installs for VB/Linux
# vagrant is optional but can be helpful

https://www.vagrantup.com/downloads.html
https://www.virtualbox.org/wiki/Downloads

vagrant --version
VBoxManage --version
vagrant box add bento/centos-7.2 --provider=virtualbox
vagrant init bento/centos-7.2
vagrant up
vagrant ssh

# install the ChefDK

curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 0.18.30

chef --version

# install your text editor of choice! vim, emacs, or nano

sudo yum install vim -y
sudo yum install emacs -y
sudo yum install nano -y

# Standard Resource Definition:

type 'name' do
  properties
  action
end

# example of a file resource

file '/path/to/file' do
  content 'file content'
  action :create
end

# setting up Cookbooks

chef --help
chef generate --help

mkdir cookbooks
chef generate cookbook cookbooks/

# The 'tree' is a tool to look at directory structure of your cookbook.

sudo yum install tree -y
tree

➜  tomcat_wrapper git:(master) tree
.
├── Berksfile
├── LICENSE
├── README.md
├── chefignore
├── metadata.rb
├── recipes
│   ├── default.rb
│   └── helloworld_example.rb
├── spec
│   ├── spec_helper.rb
│   └── unit
│       └── recipes
│           └── default_spec.rb
└── test
    └── integration
        └── default
            └── default_test.rb

7 directories, 10 files

# Run-Lists
# The generate format for a run-list is:

# "recipe[cookbook::recipe]"

# The run-list is an ordered collection of recipes to execute. This means you can run a list of recipes
# in order with the following syntax:

# "recipe[cookbook1::recipe],recipe[cookbook2::recipe],recipe[cookbook3]"

# You can execute a particular recipe, like server.rb, with this syntax:

sudo chef-client --local-mode --runlist "recipe[::server]"

# This will execute the server.rb recipe, but allow it to use any components included inside of the
# cookbook.

# When a run-list is supplied, ommiting the recipe that should be executed
# will run the default.rb recipe.

# Once you've moved into the chef-repo, check your connectivity to the
# Hosted Chef organization you created with:

knife client list

# which should return ORGANIZATION_NAME-validator. If so, you're connected!
# If not, check to make sure you've navigated into the chef-repo directory.

➜  chef-repo:(master) knife client list
thornton-validator
ubuntu1
ubuntu2
ubuntu3

➜  tomcat git:(master) ✗ tree
.
├── CHANGELOG.md
├── CONTRIBUTING.md
├── README.md
├── libraries
│   ├── matchers.rb
│   └── service_helpers.rb
├── metadata.json
├── recipes
│   └── default.rb
├── resources
│   ├── install.rb
│   ├── service_systemd.rb
│   ├── service_sysv_init.rb
│   └── service_upstart.rb
└── templates
    ├── init_systemd.erb
    ├── init_sysv.erb
    ├── init_upstart.erb
    └── setenv.erb

4 directories, 15 files

# From the chef-repo directory, you can now upload the cookbook to the Chef server:

knife cookbook upload tomcat_wrapper

# Make sure you're in the proper directory ~/chef-repo/ in order to upload the cookbook.
# You can check your work with:

knife cookbook list

2               5.0.1
apt                   7.0.0
build-essential       8.1.1
chef_client_updater   3.3.3
homebrew              5.0.4
java                  2.0.1
mingw                 2.0.2
mongodb3              5.3.0
mongodb_spec          0.0.0
openssl               8.1.2
packagecloud          1.0.0
passenger_2     3.0.1
poise                 2.8.1
poise-archive         1.5.0
poise-languages       2.1.2
poise-python          1.7.0
runit                 1.7.8
sc-mongodb            1.0.1
scottmongodb          0.1.0
seven_zip             2.0.2
starter               1.0.0
tomcat                3.0.0
tomcat2               0.1.0
tomcat8               1.0.0
tomcat_wrapper        0.1.0
user                  0.7.0
windows               4.2.2
yum                   5.1.0

Scott:chef-repo root# chef generate cookbook sc-mongodb
Hyphens are discouraged in cookbook names as they may cause problems with custom resources. See https://docs.chef.io/ctl_chef.html#chef-generate-cookbook for more information.
Generating cookbook sc-mongodb
- Ensuring correct cookbook file content
- Committing cookbook files to git
- Ensuring delivery configuration
- Ensuring correct delivery build cookbook content
- Adding delivery configuration to feature branch
- Adding build cookbook to feature branch
- Merging delivery content feature branch to master

Your cookbook is ready. Type `cd sc-mongodb` to enter it.

There are several commands you can run to get started locally developing and testing your cookbook.
Type `delivery local --help` to see a full list.

Why not start by writing a test? Tests for the default recipe are stored at:

test/integration/default/default_test.rb

If you'd prefer to dive right in, the default recipe can be found at:

recipes/default.rb

Scott:chef-repo root# cd sc-mongodb
Scott:sc-mongodb root# berks install
Resolving cookbook dependencies...
Fetching 'sc-mongodb' from source at .
Fetching cookbook index from https://supermarket.chef.io...
Using sc-mongodb (0.1.0) from source at .

Scott:sc-mongodb root# berks package
Cookbook(s) packaged to /Users/sthornto/chef-repo/sc-mongodb/cookbooks-1524925832.tar.gz

Scott:sc-mongodb root# berks upload
/opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/ridley-5.1.1/lib/ridley/client.rb:271:in `server_url': Ridley::Client#url_prefix at /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/ridley-5.1.1/lib/ridley/client.rb:79 forwarding to private method Celluloid::PoolManager#url_prefix
Uploaded sc-mongodb (0.1.0) to: 'https://api.chef.io:443/organizations/thornton'

# Bootstrapping
https://docs.chef.io/knife_bootstrap.html
https://docs.chef.io/install_bootstrap.html
http://docs.aws.amazon.com/quickstart/latest/chef-server/bootstrapping.html

# For this, you'll need a couple of things:

# Bootstrapping the node authenticates to the Chef server, installs the chef-client,
# and performs the first chef-client run with the provided run-list.

# When using user credentials to bootstrap, the command is as follows:

knife bootstrap FQDN -x USERNAME -P PASSWORD --sudo -N NODE_NAME -r RUN_LIST

knife bootstrap 192.168.54.160 --ssh-user chef --sudo --identity-file /Users/sthornto/chef-repo/scthornton.pem  --node-name ubuntu1

# When using an identity file, the format is:

knife bootstrap FQDN -x USERNAME -i /PATH/TO/IDENTITY_FILE --sudo -N NODE_NAME -r RUN_LIST

# Always bootstrap instances from the chef-repo directory.

# Test deployments with kitchen

https://docs.chef.io/kitchen.html
https://docs.chef.io/config_yml_kitchen.html
https://docs.chef.io/ctl_kitchen.html
http://kitchen.ci/
https://docs.chef.io/inspec.html
http://inspec.io/docs/

# chef-repo/cookbooks/tomcat/.kitchen.yml

# From within the tomcat cookbook, you'll want to modify the .kitchen.yml file

# contents of ~/chef-repo/cookbooks/tomcat/.kitchen.yml
#
---
driver:
  name: vagrant

provisioner:
  name: chef_zero

verifier:
  name: inspec

platforms:
  - name: centos-7.2

suites:
  - name: default
    run_list:
      - recipe[tomcat::default]
    verifier:
      inspec_tests:
        - test/recipes
    attributes:

#
#

# Then, navigate into the cookbook

cd cookbooks/tomcat
kitchen list

# running 'kitchen list' should return the name of your virtual machine.
# If the list displays properly, you should be able to run:

kitchen create
kitchen converge

# If the 'kitchen converge' process does not complete properly, make sure
# you don't have any syntax errors in your recipe

# You can login to the kitchen instance with 'kitchen login'. If you are unable
# to login to the instance, you can still proceed with the exercises, but you may want
# to consider installing the kitchen-vagrant Ruby gem by running:

chef gem install kitchen-vagrant

# https://github.com/test-kitchen/kitchen-vagrant
# https://rubygems.org/gems/kitchen-vagrant/

# You can execute any tests inside of the cookbooks/tomcat/test/recipes/default.rb


kitchen verify

# At least one test will fail if you run 'kitchen verify' out-of-the-box, without
# modifying the default test.

# content of ~/chef-repo/cookbooks/tomcat/recipes/default.rb
#

describe port(80) do
  it { should be_listening }
end

describe command('curl localhost') do
  its(:stdout) { should match(/Hello, world!/) }
end

#
#

kitchen verify

# Don't forget to clean up your work by running 'kitchen destroy'!

kitchen destroy

# You can also look into the 'kitchen test' command to further automate testing.

https://docs.chef.io/ctl_kitchen.html#kitchen-test

https://docs.chef.io/manage.html
https://docs.chef.io/server_manage_nodes.html
https://docs.chef.io/server_manage_clients.html
https://docs.chef.io/server_manage_cookbooks.html
https://docs.chef.io/server_orgs.html
https://docs.chef.io/server_users.html


https://blog.chef.io/2013/12/03/doing-wrapper-cookbooks-right/
https://blog.chef.io/2017/02/14/writing-wrapper-cookbooks/

root@ubuntu2:/run# chef-client
Starting Chef Client, version 13.8.5
resolving cookbooks for run list: ["tomcat", "tomcat_wrapper", "tomcat_wrapper::helloworld_example"]
Synchronizing Cookbooks:
  - tomcat (3.0.0)
  - homebrew (5.0.4)
  - java (2.0.1)
  - windows (4.2.2)
  - tomcat_wrapper (0.1.0)
Installing Cookbook Gems:
Compiling Cookbooks...
[2018-05-03T17:03:38-04:00] WARN: The default tomcat recipe does nothing. See the readme for information on using the tomcat resources
Converging 12 resources
Recipe: tomcat_wrapper::default
  * apt_update[update] action periodic (up to date)
Recipe: java::notify
  * log[jdk-version-changed] action nothing (skipped due to action :nothing)
Recipe: java::openjdk
  * apt_repository[openjdk-r-ppa] action add
    * execute[apt-cache gencaches] action nothing (skipped due to action :nothing)
    * apt_update[openjdk-r-ppa] action nothing (skipped due to action :nothing)
    * execute[install-key DA1A4A13543B466853BAF164EB9B1D8886F44E2A] action run (skipped due to not_if)
    * file[/etc/apt/sources.list.d/openjdk-r-ppa.list] action create (up to date)
     (up to date)
  * apt_package[openjdk-8-jdk, openjdk-8-jre-headless] action install (up to date)
  * java_alternatives[set-java-alternatives] action set (up to date)
Recipe: java::default_java_symlink
  * link[/usr/lib/jvm/default-java] action create (up to date)
Recipe: java::set_java_home
  * directory[/etc/profile.d] action create (up to date)
  * template[/etc/profile.d/jdk.sh] action create (up to date)
Recipe: tomcat_wrapper::helloworld_example
  * linux_user[chefed] action create (up to date)
  * group[cool_group] action create (up to date)
  * tomcat_install[helloworld] action install
    * apt_package[tar] action install (up to date)
    * group[cool_group] action create (up to date)
    * linux_user[cool_user] action create (up to date)
    * directory[tomcat install dir] action create (up to date)
    * remote_file[apache 8.0.47 tarball] action create (up to date)
    * execute[extract tomcat tarball] action run (up to date)
    * execute[chown install dir as tomcat_helloworld] action run (skipped due to not_if)
    * link[/opt/tomcat_helloworld] action create (up to date)
     (up to date)
  * tomcat_service_systemd[helloworld] action start
    * template[/etc/systemd/system/tomcat_helloworld.service] action create
      - create new file /etc/systemd/system/tomcat_helloworld.service
      - update content in file /etc/systemd/system/tomcat_helloworld.service from none to 5ce8e2
      - suppressed sensitive resource
      - change mode from '' to '0644'
      - change owner from '' to 'root'
      - change group from '' to 'root'
    * execute[Load systemd unit file] action run
      - execute systemctl daemon-reload
    * execute[Load systemd unit file] action nothing (skipped due to action :nothing)
    * service[tomcat_helloworld] action start
      - start service service[tomcat_helloworld]
    * service[tomcat_helloworld] action restart
      - restart service service[tomcat_helloworld]

  * tomcat_service_systemd[helloworld] action enable
    * template[/etc/systemd/system/tomcat_helloworld.service] action create (up to date)
    * execute[Load systemd unit file] action nothing (skipped due to action :nothing)
    * service[tomcat_helloworld] action enable
      - enable service service[tomcat_helloworld]


Running handlers:
Running handlers complete
Chef Client finished, 7/33 resources updated in 20 seconds


# tomcat_wrapper
# tomcat_wrapper
