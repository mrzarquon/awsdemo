# this is the pe_node defined type
# this is for automating an installation of PE on a redhat 7 host, specifically
# the AIO, Master, PuppetDB or Console Roles.
define awsdemo::pe_node(
  $availability_zone,
  $image_id,
  $region,
  $instance_type,
  $security_groups,
  $subnet,
  $department,
  $project,
  $created_by,
  $key_name,
  $pe_admin_password,
  $pe_role,
  $pe_build,
  $pe_dns_altnames,
  $iam_profile,
  $r10k_repo = 'https://github.com/mrzarquon/aws-control-repo.git',
  $nodename = $title,
) {
  $pp_role = $pe_role
  $pp_created_by = $created_by
  $pp_department = $department
  $pp_project = $project

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
    ebs_optimized             => 'true',
    tags                      => {
      'department'            => $pp_department,
      'project'               => $pp_project,
      'created_by'            => $pp_created_by,
      'pe_role'               => $pe_role,
      'pe_build'              => $pe_build,
    },
    user_data     => template('awsdemo/pe_node.erb'),
    block_devices => [{
      device_name           => '/dev/sdb',
      volume_size           => '100',
      volume_type           => 'io1',
      delete_on_termination => 'true',
      encrypted             => 'true',
      iops                  => '1500',
    }],
  }
}
