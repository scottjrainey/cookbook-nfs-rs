maintainer       "Scott Rainey"
maintainer_email "scott@scottjrainey.com"
license          "Apache 2.0"
description      "Rightscale compatible version of cookbook-nfs - Installs and configures nfs, and NFS exports"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name "nfs"
version          "0.3.1"
recipe "nfs", "Installs and configures nfs client components"
recipe "nfs::server", "Installs and configures nfs server components"
recipe "nfs::exports", "Templates the exports file from attribute or LWRP"
recipe "nfs::undo", "Undo both default and server recipes"

%w{ ubuntu debian redhat centos fedora scientific amazon oracle }.each do |os|
  supports os
end

depends "line"

