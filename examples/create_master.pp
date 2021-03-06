awsdemo::pe_node { 'tse-testmaster' :
  availability_zone => 'us-west-2a',
  image_id          => 'ami-4dbf9e7d',
  region            => 'us-west-2',
  instance_type     => 'm4.xlarge',
  security_groups   => [
    'tse-master',
    'tse-crossconnect'
  ],
  subnet            => 'tse-subnet-avza-1',
  department        => 'tse',
  project           => 'awsdemo',
  created_by        => 'chrisbarker',
  key_name          => 'chris.barker',
  pe_admin_password => 'puppetlabs',
  pe_role           => 'aio',
  pe_build          => '2015.2.2',
  pe_dns_altnames   => 'tsemaster',
  iam_profile       => 'puppetlabs_aws_provisioner',
}
