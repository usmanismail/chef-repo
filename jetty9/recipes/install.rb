case node["platform"]
	when "centos","redhat","fedora"
		package 'java6' do
		  package_name 'java-1.6.0-openjdk'
		  action :remove
		end

		package 'java7' do
		  package_name 'java-1.7.0-openjdk'
		  action :install
		end 
	when 'debian', 'ubuntu'
		bash "update-apt-repository" do
  		user "root"
  		code <<-EOH
  			apt-get update
  		EOH
		end

		package 'java7' do
		  package_name 'openjdk-7-jdk'
		  action :install
		end 		
end

package 'chkconfig' do 
	action:install
end


jetty_Tarball = "/tmp/jetty.tar.gz"

remote_file jetty_Tarball do
  source "http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-#{node['jetty']['version']}.tar.gz"
end

jetty_Tarball

bash 'extract_jetty' do
  code <<-EOH
    tar xzf #{jetty_Tarball} -C #{"/opt/"}
    mv /opt/jetty-distribution-* /opt/jetty
    cp /opt/jetty/modules/npn/npn-1.7.0_45.mod /opt/jetty/modules/npn/npn-1.7.0_51.mod
    EOH
end

user 'jetty' do 
	system true
	action:create
end

bash 'chown_jetty' do
  code <<-EOH
    chown -R jetty:jetty /opt/jetty
  EOH
end

bash 'setup_Service' do
  code <<-EOH
    ln -s /opt/jetty/bin/jetty.sh /etc/init.d/jetty
    ln -s /usr/lib/insserv/insserv /sbin/insserv
	chkconfig --add jetty
	chkconfig jetty on
  EOH
end

template "/etc/default/jetty" do
  source "jetty.erb"
end

bash 'start_Service' do
  code <<-EOH
    service jetty start
  EOH
end

