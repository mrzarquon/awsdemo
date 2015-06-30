class tse_awsnodes (
  $region = 'us-west-2',
  $department = 'TSE',
  $project = 'Infrastructure',
  $vpc_mask = '10.90.0.0',
  $zone_a_mask = '10.90.10.0',
  $zone_b_mask = '10.90.20.0',
  $zone_c_mask = '10.90.30.0',
  $created_by,
) inherits awsdemo::params {
  $public_key = split($ec2_public_keys_0_openssh_key, ' ')
  $key_name = $public_key[2]

  awsdemo::linuxnode { "redhat7-${ec2_tags['created_by']}-01":
    image_id           => $awsdemo::params::redhat7,
    pp_project         => $ec2_tags['project'],
    pp_created_by      => $ec2_tags['created_by'],
    key_name           => $key_name,
    pe_master_hostname => $::ec2_local_hostname,
  }
  
}
