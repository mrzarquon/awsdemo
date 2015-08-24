#!/bin/bash

# PE 2015.2 Installer Prototype
# Updated install methods for testing 2015.2 installs

PE_BUILD='2015.2.0'
PE_DOWNLOAD_URL='https://s3.amazonaws.com/pe-builds/released/'
PE_DNS_ALTNAMES='aws,testing'
PE_PASSWORD='puppetlabs'
AWS_MD_URL='http://169.254.169.254/latest/meta-data/'
PRIVATE_HOSTNAME=$(curl -fs $AWS_MD_URL/hostname)
INSTANCE_ID=$(curl -fs $AWS_MD_URL/instance-id)

function write_aio_answers() {
  cat > /opt/awsdemo/answers.txt << ANSWERS
q_all_in_one_install=y
q_backup_and_purge_old_configuration=n
q_backup_and_purge_old_database_directory=n
q_database_host=localhost
q_database_install=y
q_install=y
q_pe_database=y
q_puppet_cloud_install=y
q_puppet_enterpriseconsole_auth_password=$PE_PASSWORD
q_puppet_enterpriseconsole_httpd_port=443
q_puppet_enterpriseconsole_install=y
q_puppet_enterpriseconsole_master_hostname=$PRIVATE_HOSTNAME
q_puppet_enterpriseconsole_smtp_host=localhost
q_puppet_enterpriseconsole_smtp_password=
q_puppet_enterpriseconsole_smtp_port=25
q_puppet_enterpriseconsole_smtp_use_tls=n
q_puppet_enterpriseconsole_smtp_user_auth=n
q_puppet_enterpriseconsole_smtp_username=
q_puppet_symlinks_install=y
q_puppetagent_certname=$PRIVATE_HOSTNAME
q_puppetagent_install=y
q_puppetagent_server=$PRIVATE_HOSTNAME
q_puppetdb_hostname=$PRIVATE_HOSTNAME
q_puppetdb_install=y
q_puppetdb_port=8081
q_puppetmaster_certname=master-$INSTANCE_ID
q_puppetmaster_dnsaltnames=$PRIVATE_HOSTNAME,puppet,$PE_DNS_ALTNAMES
q_puppetmaster_enterpriseconsole_hostname=localhost
q_puppetmaster_enterpriseconsole_port=443
q_puppetmaster_install=y
q_run_updtvpkg=n
q_vendor_packages_install=y
ANSWERS
}

function write_csr_attributes () {
  if [ ! -d /etc/puppetlabs/puppet ]; then
    mkdir -p /etc/puppetlabs/puppet
  fi

  cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
---
extension_requests:
  pp_instance_id: $INSTANCE_ID
  1.3.6.1.4.1.34380.1.1.13: 'aiomaster'
YAML
}

function create_opt {
  /sbin/parted -s /dev/xvdb mklabel gpt
  /sbin/parted -s /dev/xvdb mkpart primary 0% 100%
  /sbin/mkfs.ext4 /dev/xvdb1
  mount /dev/xvdb1 /opt
  echo "/dev/xvdb1              /opt                    ext4    defaults        0 2" >> /etc/fstab
  lsblk
}

function configure_redhat() {

  echo "Disabling SELinux, setting time"
  setenforce 0

  #living on the edge
  sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

  yum install -y ntpdate

  ntpdate -u 0.amazon.pool.ntp.org

}

function install_pe() {
  echo "Installing Puppet Enterprise ${PE_BUILD}"
  if [ ! -d /opt/awsdemo/pe ]; then
    mkdir -p /opt/awsdemo/pe
  fi
  if [ ! -f /opt/awsdemo/pe/puppet-enterprise-installer ]; then
    curl -L -o /opt/awsdemo/pe-installer.tar.gz "https://pm.puppetlabs.com/cgi-bin/download.cgi?ver=$PE_BUILD&dist=el&arch=x86_64&rel=7"
    tar --extract --file=/opt/awsdemo/pe-installer.tar.gz --strip-components=1 --directory=/opt/awsdemo/pe/
  fi

  write_aio_answers

  /opt/awsdemo/pe/puppet-enterprise-installer -a /opt/awsdemo/answers.txt

  # nuke autosign for right now, we might fix this with a module later for certsigner
  echo "*" > /etc/puppetlabs/puppet/autosign.conf
  service pe-puppetserver restart
}

function provision_puppet() {

  configure_redhat

  create_opt

  install_pe

}

provision_puppet
