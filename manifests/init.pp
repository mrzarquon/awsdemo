# This is the example awsdemo module
# you need to write a profile for this to work
# with the profile written, you could then call 'puppet apply your_profile.pp'
# from any machine with this module installed and get a working PE demo env
class awsdemo (
  $availability_zone,
  $region,
  $aws_keyname,
  $created_by,
  $project,
  $department,
  $master_iam_profile,
  $master_instance_type = 'm4.xlarge',
  $pe_build = '2015.2.0',
  $vpc_mask    = '10.90.0.0',
  $zone_a_mask = '10.90.10.0',
  $zone_b_mask = '10.90.20.0',
  $zone_c_mask = '10.90.30.0',
  $image_ids = $awsdemo::params::image_ids,
) inherits awsdemo::params {
  $pe_admin_password = fqdn_rand_string(32, '', "${created_by}${project}${department}${pe_build}")

  notify {"PE Admin console initial password is: ${pe_admin_password}": }

  awsdemo::vpc { "${project}-${department}":
    region      => $region,
    department  => $department,
    project     => $project,
    vpc_mask    => $vpc_mask,
    zone_a_mask => $zone_a_mask,
    zone_b_mask => $zone_b_mask,
    zone_c_mask => $zone_c_mask,
    created_by  => $created_by,
  }
  awsdemo::pe_node { "${project}-${department}-${created_by}-master":
    availability_zone => $availability_zone,
    image_id          => $image_ids[$region]['redhat7'],
    region            => $region,
    instance_type     => $master_instance_type,
    security_groups   => [
      "${project}-${department}-master",
      "${project}-${department}-crossconnect"
    ],
    subnet            => "${project}-${department}-avza",
    department        => $department,
    project           => $project,
    created_by        => $created_by,
    key_name          => $aws_keyname,
    pe_admin_password => $pe_admin_password,
    pe_role           => 'aio',
    pe_build          => $pe_build,
    pe_dns_altnames   => 'master',
    iam_profile       => $master_iam_profile,
    require           => Awsdemo::Vpc["${project}-${department}"]
  }
}
