# This is a vpc defined type
# it provides the following:
# VPC, three subnets, an internet gateway, default routes between all subnets
# and access to the internet
# By default all subnets auto map to public IP on launch
define awsdemo::vpc (
  $created_by,
  $region = 'us-west-2',
  $department = 'TSE',
  $project = 'Infrastructure',
  $vpc_mask = '10.90.0.0',
  $zone_a_mask = '10.90.10.0',
  $zone_b_mask = '10.90.20.0',
  $zone_c_mask = '10.90.30.0',
) {

  $aws_tags = {
    'department' => $department,
    'project'    => $project,
    'created_by' => $created_by,
  }

  $vpc_name = "${name}-vpc"
  $igw_name = "${name}-igw"
  $routes_name = "${name}-routes"


  ec2_vpc { $vpc_name:
    ensure     => present,
    region     => $region,
    cidr_block => "${vpc_mask}/16",
    tags       => $aws_tags,
  }

  ec2_vpc_subnet { "${name}-avza":
    ensure                  => present,
    region                  => $region,
    vpc                     => $name,
    cidr_block              => "${zone_a_mask}/24",
    availability_zone       => "${region}a",
    route_table             => $routes_name,
    map_public_ip_on_launch => true,
    require                 => Ec2_vpc[$vpc_name],
    tags                    => $aws_tags,
  }
  ec2_vpc_subnet { "${name}-avzb":
    ensure                  => present,
    region                  => $region,
    vpc                     => $name,
    cidr_block              => "${zone_b_mask}/24",
    availability_zone       => "${region}b",
    route_table             => $routes_name,
    map_public_ip_on_launch => true,
    require                 => Ec2_vpc[$vpc_name],
    tags                    => $aws_tags,
  }
  ec2_vpc_subnet { "${name}-avzc":
    ensure                  => present,
    region                  => $region,
    vpc                     => $name,
    cidr_block              => "${zone_c_mask}/24",
    availability_zone       => "${region}c",
    route_table             => $routes_name,
    map_public_ip_on_launch => true,
    require                 => Ec2_vpc[$vpc_name],
    tags                    => $aws_tags,
  }

  ec2_vpc_internet_gateway { $igw_name:
    ensure  => present,
    region  => $region,
    vpc     => $name,
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

}
