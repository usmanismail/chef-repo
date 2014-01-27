
include_recipe 'java::default'

package 'chkconfig' do 
	action:install
end


jetty_Tarball = "/tmp/jetty.tar.gz"

remote_file jetty_Tarball do
  source "http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-#{node['jetty']['version']}.tar.gz"
end

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



template "/etc/default/jetty" do
  source "jetty.erb"
end

bash 'setup_JettyInitd' do
  code <<-EOH
    ln -s /opt/jetty/bin/jetty.sh /etc/init.d/jetty
  EOH
end

service 'jetty' do
	action:enable
end

service 'jetty' do
	action:start
end

