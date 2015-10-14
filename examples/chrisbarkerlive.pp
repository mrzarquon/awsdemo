class {'awsdemo':
  availability_zone  => 'us-west-2a',
  region             => 'us-west-2',
  aws_keyname        => 'chris.barker',
  created_by         => 'chrisbarker',
  project            => 'awslive',
  department         => 'tse',
  master_iam_profile => 'puppetlabs_provisioner',
}
