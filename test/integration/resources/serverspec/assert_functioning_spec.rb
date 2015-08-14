require 'serverspec'

set :backend, :exec
puts "os: #{os}"

docker_version_string = `docker -v`
docker_version = docker_version_string.split(/\s/)[2].split(',')[0]

volumes_filter = '{{ .Volumes }}' if docker_version =~ /1.6/
volumes_filter = '{{ .Volumes }}' if docker_version =~ /1.7/
volumes_filter = '{{ .Config.Volumes }}' if docker_version =~ /1.8/

mounts_filter = '{{ .Volumes }}' if docker_version =~ /1.6/
mounts_filter = '{{ .Volumes }}' if docker_version =~ /1.7/
mounts_filter = '{{ .Mounts }}' if docker_version =~ /1.8/

##############################################
#  test/cookbooks/docker_test/recipes/image.rb
##############################################

# test/cookbooks/docker_test/recipes/image.rb

# docker_image[hello-world]

describe command('docker images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^hello-world\s.*latest/) }
end

# docker_image[Tom's container]

describe command('docker images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{^tduffield\/testcontainerd\s.*latest}) }
end

# docker_image[busybox]

describe command('docker images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^busybox\s.*latest/) }
end

# docker_image[alpine]

describe command('docker images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^alpine\s.*3.1/) }
end

# docker_image[vbatts/slackware]

describe command('docker images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/^slackware\s.*latest/) }
end

# docker_image[save hello-world]

describe file('/hello-world.tar') do
  it { should be_file }
  it { should be_mode 644 }
end

# docker_image[image-1]

describe command('docker images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/^image-1\s.*v1.0.1/) }
end

# docker_image[image.2]

describe command('docker images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/^image.2\s.*v1.0.1/) }
end

# docker_image[image_3]

describe command('docker images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/^image_3\s.*v1.0.1/) }
end

# docker_image[name-w-dashes]

describe command('docker images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^localhost\:5043\/someara\/name-w-dashes\s.*latest/) }
end

# docker_tag[private repo tag for name.w.dots:latest]

describe command('docker images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{^localhost\:5043\/someara\/name\.w\.dots\s.*latest}) }
end

# FIXME: We need to test the "docker_registry" stuff...
# I can't figure out how to search the local registry to see if the
# authentication and :push actions in the test recipe actually worked.
#
# Skipping for now.

##################################################
#  test/cookbooks/docker_test/recipes/container.rb
##################################################

# docker_container[hello-world]

describe command("docker ps -af 'name=hello-world'") do
  its(:exit_status) { should eq 0 }
end

# docker_container[busybox_ls]

describe command("[ ! -z `docker ps -qaf 'name=busybox_ls$'` ]") do
  its(:exit_status) { should eq 0 }
end

# docker_container[alpine_ls]

describe command("[ ! -z `docker ps -qaf 'name=alpine_ls$'` ]") do
  its(:exit_status) { should eq 0 }
end

# docker_container[an_echo_server]

describe command("[ ! -z `docker ps -qaf 'name=an_echo_server$'` ]") do
  its(:exit_status) { should eq 0 }
end

# docker_container[another_echo_server]

describe command("[ ! -z `docker ps -qaf 'name=another_echo_server$'` ]") do
  its(:exit_status) { should eq 0 }
end

# docker_container[an_udp_echo_server]

describe command("[ ! -z `docker ps -qaf 'name=an_udp_echo_server$'` ]") do
  its(:exit_status) { should eq 0 }
end

describe command("[ ! -z `docker ps -qaf 'name=a_multiport_echo_server$'` ]") do
  its(:exit_status) { should eq 0 }
end

# docker_container[bill]

describe command("[ ! -z `docker ps -qaf 'name=bil$'` ]") do
  its(:exit_status) { should eq 1 }
end

# docker_container[hammer_time]

describe command("[ ! -z `docker ps -qaf 'name=hammer_time$'` ]") do
  its(:exit_status) { should eq 0 }
end

describe command("docker ps -af 'name=hammer_time$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited \(137\)/) }
end

# docker_container[red_light]

describe command("[ ! -z `docker ps -qaf 'name=red_light$'` ]") do
  its(:exit_status) { should eq 0 }
end

describe command("docker ps -af 'name=red_light$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Paused/) }
end

# docker_container[green_light]

describe command("[ ! -z `docker ps -qaf 'name=green_light$'` ]") do
  its(:exit_status) { should eq 0 }
end

describe command("docker ps -af 'name=green_light$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/Paused/) }
end

# docker_container[quitter]

describe command("[ ! -z `docker ps -qaf 'name=quitter$'` ]") do
  its(:exit_status) { should eq 0 }
end

describe command("docker ps -af 'name=quitter$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/Exited/) }
end

# docker_container[restarter]

describe command("[ ! -z `docker ps -qaf 'name=restarter$'` ]") do
  its(:exit_status) { should eq 0 }
end

describe command("docker ps -af 'name=restarter$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/Exited/) }
end

# docker_container[deleteme]

describe command("[ ! -z `docker ps -qaf 'name=deleteme$'` ]") do
  its(:exit_status) { should eq 1 }
end

# docker_container[redeployer]

describe command("docker ps -af 'name=redeployer$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/Exited/) }
end

# docker_container[bind_mounter]

describe command("docker ps -af 'name=bind_mounter$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command("docker inspect -f \"{{ .HostConfig.Binds }}\" bind_mounter") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{\[\/hostbits\:\/bits \/more-hostbits\:\/more-bits\]}) }
end

# docker_container[chef_container]

describe command("docker ps -af 'name=chef_container$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/Exited/) }
  its(:stdout) { should_not match(/Up/) }
end

describe command("docker inspect -f \"#{ volumes_filter }\" chef_container") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{\/opt\/chef\:}) }
end

# docker_container[ohai_debian]

describe command("docker ps -af 'name=ohai_debian$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command("docker inspect -f \"#{ mounts_filter }\" ohai_debian") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{\/opt\/chef}) }
end

# docker_container[env]

describe command("docker ps -af 'name=env$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command("docker inspect -f \"{{ .Config.Env }}\" env") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{\[PATH=\/usr\/bin FOO=bar\]}) }
end

# docker_container[ohai_again_debian
describe command("[ ! -z `docker ps -aqf 'name=sean_was_here$'` ]") do
  its(:exit_status) { should eq 1 }
end

describe command('docker run --rm --volumes-from chef_container debian ls -la /opt/chef/') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/sean_was_here-/) }
end

# docker_container[cap_add_net_admin]

describe command("docker ps -af 'name=cap_add_net_admin$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command('docker logs cap_add_net_admin') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should_not match(/RTNETLINK answers: Operation not permitted/) }
end

# docker_container[cap_add_net_admin_error]

describe command("docker ps -af 'name=cap_add_net_admin_error$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command('docker logs cap_add_net_admin_error') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match(/RTNETLINK answers: Operation not permitted/) }
end

# docker_container[cap_drop_mknod]

describe command("docker ps -af 'name=cap_drop_mknod$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command('docker logs cap_drop_mknod') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match(%r{mknod: '/dev/urandom2': Operation not permitted}) }
end

# docker_container[cap_drop_mknod_error]

describe command("docker ps -af 'name=cap_drop_mknod_error$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command('docker logs cap_drop_mknod_error') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should_not match(%r{mknod: '/dev/urandom2': Operation not permitted}) }
end

# docker_container[fqdn]

describe command("docker ps -af 'name=fqdn$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command('docker logs fqdn') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/computers.biz/) }
end

# docker_container[dns]

describe command("docker ps -af 'name=dns$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command("docker inspect -f \"{{ .HostConfig.Dns }}\" dns") do
  its(:stdout) { should match(/\[4.3.2.1 1.2.3.4\]/) }
end

# docker_container[extra_hosts]

describe command("docker ps -af 'name=extra_hosts$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command("docker inspect -f \"{{ .HostConfig.ExtraHosts }}\" extra_hosts") do
  its(:stdout) { should match(/\[east:4.3.2.1 west:1.2.3.4\]/) }
end

# docker_container[devices_sans_cap_sys_admin]

# describe command("docker ps -af 'name=devices_sans_cap_sys_admin$'") do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match(/Exited/) }
# end

# FIXME: find a method to test this that works across all platforms in test-kitchen
# Is this test invalid?
# describe command("md5sum /root/disk1") do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match(/0f343b0931126a20f133d67c2b018a3b/) }
# end

# docker_container[devices_with_cap_sys_admin]

# describe command("docker ps -af 'name=devices_with_cap_sys_admin$'") do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match(/Exited/) }
# end

# describe command('md5sum /root/disk1') do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should_not match(/0f343b0931126a20f133d67c2b018a3b/) }
# end

# docker_container[cpu_shares]

describe command("docker ps -af 'name=cpu_shares$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command("docker inspect -f '{{ .HostConfig.CpuShares }}' cpu_shares") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/512/) }
end

# docker_container[cpuset_cpus]

describe command("docker ps -af 'name=cpuset_cpus$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command("docker inspect -f '{{ .HostConfig.CpusetCpus }}' cpuset_cpus") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/0,1/) }
end

# docker_container[try_try_again]

# FIXME: Find better tests
describe command("docker ps -af 'name=try_try_again$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

# docker_container[reboot_survivor]

describe command("docker ps -af 'name=reboot_survivor$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/Exited/) }
end

# docker_container[reboot_survivor_retry]

describe command("docker ps -af 'name=reboot_survivor_retry$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/Exited/) }
end

# docker_container[link_source]

describe command("docker ps -af 'name=link_source$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/Exited/) }
end

# docker_container[link_target_1]

describe command("docker ps -af 'name=link_target_1$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

describe command('docker logs link_target_1') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/ping: bad address 'hello'/) }
end

# docker_container[dangler]

# describe command('ls -la `cat /dangler_volpath`') do
#   its(:exit_status) { should_not eq 0 }
# end

# FIXME: this changed with 1.8.x. Find a way to sanely test across various platforms
# docker_container[mutator]

describe command('ls -la /mutator.tar') do
  its(:exit_status) { should eq 0 }
end
