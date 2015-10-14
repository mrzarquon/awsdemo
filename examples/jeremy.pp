class {'jeremy':
  availability_zone  => 'us-west-2a',
  region             => 'us-west-2',
  aws_keyname        => 'jeremy.adams',
  created_by         => 'jeremyadams',
  project            => 'jeremy',
  department         => 'tse',
  master_iam_profile => 'puppetlabs_provisioner',
}
