# This is a vpc defined type
# it provides the following:
# VPC, three subnets, an internet gateway, default routes between all subnets
# and access to the internet
# By default all subnets auto map to public IP on launch
define awsdemo::vpc (
  $created_by,
  $region,
  $department,
  $project,
  $vpc_mask    = '10.90.0.0',
  $zone_a_mask = '10.90.10.0',
  $zone_b_mask = '10.90.20.0',
  $zone_c_mask = '10.90.30.0',
) {
  $vpc_name             = "${name}-vpc"
  $igw_name             = "${name}-igw"
  $routes_name          = "${name}-routes"
  $master_sg_name       = "${name}-master"
  $agents_sg_name       = "${name}-agents"
  $crossconnect_sq_name = "${name}-crossconnect"
  $aws_tags = {
    'department' => $department,
    'project'    => $project,
    'created_by' => $created_by,
  }

  ec2_vpc { $vpc_name:
    ensure     => present,
    region     => $region,
    cidr_block => "${vpc_mask}/16",
    tags       => $aws_tags,
  }

  ec2_vpc_subnet { "${name}-avza":
    ensure                  => present,
    region                  => $region,
    vpc                     => $vpc_name,
    cidr_block              => "${zone_a_mask}/24",
    availability_zone       => "${region}a",
    route_table             => $routes_name,
    map_public_ip_on_launch => true,
    require                 => [
      Ec2_vpc[$vpc_name],
      Ec2_vpc_routetable[$routes_name],
    ],
    tags                    => $aws_tags,
  }
  ec2_vpc_subnet { "${name}-avzb":
    ensure                  => present,
    region                  => $region,
    vpc                     => $vpc_name,
    cidr_block              => "${zone_b_mask}/24",
    availability_zone       => "${region}b",
    route_table             => $routes_name,
    map_public_ip_on_launch => true,
    require                 => [
      Ec2_vpc[$vpc_name],
      Ec2_vpc_routetable[$routes_name],
    ],
    tags                    => $aws_tags,
  }
  ec2_vpc_subnet { "${name}-avzc":
    ensure                  => present,
    region                  => $region,
    vpc                     => $vpc_name,
    cidr_block              => "${zone_c_mask}/24",
    availability_zone       => "${region}c",
    route_table             => $routes_name,
    map_public_ip_on_launch => true,
    require                 => [
      Ec2_vpc[$vpc_name],
      Ec2_vpc_routetable[$routes_name],
    ],
    tags                    => $aws_tags,
  }

  ec2_vpc_internet_gateway { $igw_name:
    ensure  => present,
    region  => $region,
    vpc     => $vpc_name,
    require => Ec2_vpc[$vpc_name],
    tags    => $aws_tags,
  }

  ec2_vpc_routetable { $routes_name:
    ensure => present,
    region => $region,
    vpc    => $vpc_name,
    routes => [
      {
        destination_cidr_block => "${vpc_mask}/16",
        gateway                => 'local',
      },
      {
        destination_cidr_block => '0.0.0.0/0',
        gateway                => $igw_name,
      },
    ],
    require  => [
      Ec2_vpc[$vpc_name],
      Ec2_vpc_internet_gateway[$igw_name],
    ],
    tags => $aws_tags,
  }

  ec2_securitygroup { $master_sg_name:
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

  ec2_securitygroup { $agents_sg_name:
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

  ec2_securitygroup { $crossconnect_sq_name:
    ensure      => present,
    region      => $region,
    vpc         => $vpc_name,
    description => 'Security Group that allows masters to talk to agents and vice versa - prevents race condition',
    ingress     => [
      {
        security_group => $master_sg_name,
      },
      {
        security_group => $agents_sg_name,
      },
    ],
    tags    => $aws_tags,
    require => Ec2_securitygroup[$master_sg_name,$agents_sg_name],
  }
}
