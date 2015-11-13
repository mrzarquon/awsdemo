define awsdemo::windowsnode (
  $pp_department,
  $pp_project,
  $pp_created_by,
  $pp_role,
  $key_name,
  $image_ids,
  $security_groups,
  $subnet,
  $pe_master_hostname = $::ec2_metadata['local-hostname'],
  $nodename           = $title,
  $availability_zone  = $::ec2_metadata['placement']['availability-zone'],
  $region             = $::ec2_region,
  $aio_version        = $::aio_version,
  $instance_type      = 'm4.large',
) {

  ec2_instance { $nodename:
    ensure            => 'running',
    availability_zone => $availability_zone,
    image_id          => $image_ids[$ec2_region]['windows2012'],
    instance_type     => $instance_type,
    key_name          => $key_name,
    region            => $region,
    security_groups   => $security_groups,
    subnet            => $subnet,
    tags              => {
      'department'    => $pp_department,
      'project'       => $pp_project,
      'created_by'    => $pp_created_by,
    },
    user_data         => template('awsdemo/windows.erb'),
  }
}
