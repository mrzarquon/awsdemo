class tse_awsnodes::params {

  case $::ec2_region {
    # North America
    'us-west-2': {
      $security_groups = ['tse-agents','tse-crossconnect']
      $redhat7 = 'ami-4dbf9e7d'
      $redhat6 = 'ami-2faa861f'
      $windows2012 = 'ami-7f634e4f'
      $windows2008 = 'ami-fd604dcd'
      $ubuntu1404 = 'ami-3b14370b'
      $ubuntu1204 = 'ami-fd7959cd'
      $amazonlinux = 'ami-7f79544f'
    }
    # Sydney
    'ap-southeast-2': {
      $security_groups = ['tse-agents','tse-crossconnect']
      $redhat7 = 'ami-d3daace9'
      $redhat6 = 'ami-e5ec9cdf'
      $windows2012 = 'ami-dd1b6be7'
      $windows2008 = 'ami-ab1b6b91'
      $ubuntu1404 = 'ami-cd4e3ff7'
      $ubuntu1204 = 'ami-e73342dd'
      $amazonlinux = 'ami-4d1e6e77'
    }
    # Europe
    # UK + Ireland
    'eu-west-1': {
      $security_groups = ['tse-agents','tse-crossconnect']
      $redhat7 = 'ami-25158352'
      $redhat6 = 'ami-837de3f4'
      $windows2012 = 'ami-5d62ff2a'
      $windows2008 = 'ami-c563feb2'
      $ubuntu1404 = 'ami-d7fd6ea0'
      $ubuntu1204 = 'ami-6fcb5a18'
      $amazonlinux = 'ami-ef158898'
    }
    default: {
      fail("This module is only meant for aws, ec2_regions: us-west-2, ap-southeast-2, eu-west-1")
    }
  }

  case $::ec2_placement_availability_zone {
    'us-west-2a', 'ap-southeast-2a', 'eu-west-1a': {
      $subnet = 'tse-subnet-avza-1'
    }
    'us-west-2b', 'ap-southeast-2b', 'eu-west-1b': {
      $subnet = 'tse-subnet-avzb-1'
    }
    default: {
      fail("This module is only meant for aws, ec2_regions: us-west-2, ap-southeast-2, eu-west-1")
    }
  }
}
