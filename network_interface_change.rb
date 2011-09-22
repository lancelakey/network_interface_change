#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'

hosts = (1..254).map {|x| "172.16.31.#{x}"}                                                                                                                                                                                                                               
username = "your_username"
password = "your_password"
cmd = "sed -i -r -e '/netmask/ s/255.255.255.0/255.255.254.0/' /etc/network/interfaces ; echo $? ; cat /etc/network/interfaces ; reboot"

hosts.each do |host|
  begin
    Net::SSH.start( host , username, :password => password, :timeout => 10) do |ssh|
      results = ssh.exec! cmd
      puts "Exit Status: %s %s" % [results, host]
    end 
  rescue Timeout::Error  
    puts "Error: Timed out %s" % host
  rescue Errno::EHOSTUNREACH  
    puts "Error: Host unreachable %s" % host 
  rescue Errno::ECONNREFUSED  
    puts "Error: Connection refused %s" % host  
  rescue Net::SSH::AuthenticationFailed  
    puts "Error: Authentication failure %s" % host
  end  
end
