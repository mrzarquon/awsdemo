#!/bin/bash

# ERB generated userdata script

PE_MASTER='ip-10-98-10-95.us-west-2.compute.internal'
AWS_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

PE_CERTNAME="${AWS_INSTANCE_ID}"

# these are attributes we know already
PP_INSTANCE_ID="${AWS_INSTANCE_ID}"

PP_IMAGE_NAME=$(curl -s http://169.254.169.254/latest/meta-data/ami-id)

function write_csr_attributes () {
  if [ ! -d /etc/puppetlabs/puppet ]; then
    mkdir -p /etc/puppetlabs/puppet
  fi

  cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
extension_requests:
  pp_instance_id: $PP_INSTANCE_ID
  pp_image_name: $PP_IMAGE_NAME
YAML
}

function install_pe_agent () {
  curl -sk https://$PE_MASTER:8140/packages/current/install.bash | /bin/bash -s agent:certname=$PE_CERTNAME
}

write_csr_attributes
install_pe_agent
