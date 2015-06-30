define awsdemo::pe_node(
  $nodename = $title,
  $availability_zone = $::ec2_placement_availability_zone,
  $image_id = $tse_awsnodes::params::redhat7,
  $region = $::ec2_region,
  $instance_type = 'm3.medium',
  $security_groups = $tse_awsnodes::params::security_groups,
  $subnet = $tse_awsnodes::params::subnet,
  $department = 'TSE',
  $project,
  $created_by,
  $key_name,
  $pe_admin_password,
  $pe_role,
  $pe_build,
  $iam_profile,
) inherits awsdemo::params {
  
  ec2_instance { $nodename:
    ensure                    => 'running',
    availability_zone         => $availability_zone,
    image_id                  => $image_id,
    instance_type             => $instance_type,
    key_name                  => $key_name,
    region                    => $region,
    security_groups           => $security_groups,
    subnet                    => $subnet,
    iam_instance_profile_name => $iam_profile,
    tags                      => {
      'department'            => $pp_department,
      'project'               => $pp_project,
      'created_by'            => $pp_created_by,
    },
    user_data     => template('awsdemo/pe_node.erb'),
    block_devices => [ 
      {
        device_name           => '/dev/sda1',
        volume_size           => '8',
        delete_on_termination => True,
      },
      {
        device_name           => '/dev/sdb',
        volume_size           => '100',
        delete_on_termination => True,
      }
    ],
    
  }


}
