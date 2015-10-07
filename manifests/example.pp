class awsdemo::example (
  $image_ids = $awsdemo::params::image_ids,
) inherits awsdemo::params {
  $pe_master_hostname = $::ec2_metadata['local-hostname']

  ec2_instance { "examplenode-${ec2_tags['created_by']}":
    ensure            => 'running',
    availability_zone => $::ec2_metadata['placement']['availability-zone'],
    image_id          => $image_ids[$ec2_region]['redhat7'],
    instance_type     => 'm4.large',
    region            => $::ec2_region,
    security_groups   => ['tse-agents','tse-crossconnect'],
    subnet            => 'tse-subnet-avza-1',
    tags              => {
      'department'    => $::ec2_tags['department'],
      'project'       => $::ec2_tags['project'],
      'created_by'    => $::ec2_tags['created_by'],
    },
    user_data         => template('awsdemo/linux.erb'),
  }

}
