define awsdemo::linuxnode (
  $nodename = $title,
  $availability_zone = $awsdemo::params::availability_zone,
  $image_id = $awsdemo::params::redhat7,
  $region = $awsdemo::params::region,
  $instance_type = 'm4.medium',
  $security_groups = $awsdemo::params::security_groups,
  $subnet = $awsdemo::params::subnet,
  $pe_version_string = $awsdemo::params::pe_version_string,
  $pp_department,
  $pp_project,
  $pp_created_by,
  $key_name,
  $pe_master_hostname,
) {
  include awsdemo::params

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
    user_data         => template('tse_awsnodes/linux.erb'),
  }

}
