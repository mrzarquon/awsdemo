class tse_awsnodes::example {
  include tse_awsnodes::params
 
  ec2_instance { "examplenode-${ectags['created_by']}":
    ensure            => 'running',
    availability_zone => '$::ec2_placement_availability_zone',
    image_id          => $tse_awsnodes::params::amazonlinux,
    instance_type     => 't2.micro',
    region            => $ec2region,
    security_groups   => ['tse-agents','tse-crossconnect'],
    subnet            => $tse_awsnodes::params::subnet,
    tags              => {
      'department'    => $ec2tags['department'],
      'project'       => $ec2tags['project'],
      'created_by'    => $ec2tags['created_by'],
    },
    user_data         => template('tse_awsnodes/linux.erb'),
  }

}
