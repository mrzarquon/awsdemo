define awsdemo::securitygroups (
  $region = 'us-west-2',
  $department = 'TSE',
  $project = 'Infrastructure',
  $vpc_mask = '10.90.0.0',
  $vpc_name = $name,
  $created_by,
) {
  $aws_tags = {
    'department' => $department,
    'project'    => $project,
    'created_by' => $created_by,
  }

  ec2_securitygroup { "${name}-master":
    ensure      => present,
    region      => $region,
    vpc         => $vpc_name,
    description => 'Security group for use by the Master, and associated ports',
    ingress     => [
      {
        protocol => 'tcp',
        port     => '80',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '22',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '443',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '3000',
        cidr     => '0.0.0.0/0',
      },
      {
        cidr => "${vpc_mask}/16", 
        port => '-1', 
        protocol => 'icmp'
      },
    ],
    tags => $aws_tags,
  }

  ec2_securitygroup { "${name}-agents":
    ensure      => present,
    region      => $region,
    vpc         => $vpc_name,
    description => 'Security group for use by the agents - allows their port access to master also',
    ingress     => [
      {
        protocol => 'tcp',
        port     => '80',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '22',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '443',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '3389',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '8080',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '8000',
        cidr     => '0.0.0.0/0',
      },
      {
        cidr => "${vpc_mask}/16", 
        port => '-1', 
        protocol => 'icmp'
      },
    ],
    tags => $aws_tags,
  }


  ec2_securitygroup { "${name}-crossconnect":
    ensure      => present,
    region      => $region,
    vpc         => $vpc_name,
    description => 'Security Group that allows masters to talk to agents and vice versa - prevents race condition',
    ingress     => [
      {
        security_group => "${name}-master",
      },
      {
        security_group => "${name}-agents",
      },
    ],
    tags    => $aws_tags,
    require => Ec2_securitygroup["${name}-master","${name}-agents"],
  }
}
