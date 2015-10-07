include awsdemo::params

$public_key = split($ec2_metadata['public-keys']['0']['openssh-key'], ' ')
$key_name = $public_key[2]

Awsdemo::Linuxnode {
  pp_department   => $ec2_tags['department'],
  pp_project      => $ec2_tags['project'],
  pp_created_by   => $ec2_tags['created_by'],
  key_name        => $key_name,
  image_ids       => $awsdemo::params::image_ids,
  security_groups => ['tse-agents','tse-crossconnect'],
  subnet          => 'tse-subnet-avza-1',
}

awsdemo::linuxnode { ['redhat7-01','redhat7-02']:
  pp_role => 'webserver',
}
