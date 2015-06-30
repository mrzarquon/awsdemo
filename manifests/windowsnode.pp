define tse_awsnodes::windowsnode (
  $nodename = $title,
  $availability_zone = $::ec2_placement_availability_zone,
  $image_id = $tse_awsnodes::params::windows2012,
  $region = $::ec2_region,
  $instance_type = 'm3.medium',
  $security_groups = $tse_awsnodes::params::security_groups,
  $subnet = $tse_awsnodes::params::subnet,
  $pe_version_string = $::pe_version,
  $pp_department = 'TSE',
  $pp_project,
  $pp_created_by,
  $key_name,
  $pe_master_hostname,
) {
  include tse_awsnodes::params

  ec2_instance { $nodename:
    ensure            => 'running',
    availability_zone => $availability_zone,
    image_id          => $image_id,
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
    user_data         => template('tse_awsnodes/windows.erb'),
  }


}
