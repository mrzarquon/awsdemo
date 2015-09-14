# Params class
# this is where data is stored around which AMI belongs to the desired OS
# In theory the ami lookup could be turned into a function in the future
class awsdemo::params {

  $ami = {
    'us-west-2' => {
      'redhat7' => 'ami-4dbf9e7d',
      'redhat6' => 'ami-2faa861f',
      'windows2012' => 'ami-67c7ff57',
      'windows2008' => 'ami-73b08843',
      'ubuntu1404' => 'ami-3b14370b',
      'ubuntu1204' => 'ami-fd7959cd',
      'amazonlinux' => 'ami-7f79544f',
    },
    'ap-southeast-2' => {
      'redhat7' => 'ami-d3daace9',
      'redhat6' => 'ami-e5ec9cdf',
      'windows2012' => 'ami-f9760dc3',
      'windows2008' => 'ami-3168130b',
      'ubuntu1404' => 'ami-cd4e3ff7',
      'ubuntu1204' => 'ami-e73342dd',
      'amazonlinux' => 'ami-4d1e6e77',
    },
    'eu-west-1' => {
      'redhat7' => 'ami-25158352',
      'redhat6' => 'ami-837de3f4',
      'windows2012' => 'ami-5d62ff2a',
      'windows2008' => 'ami-c563feb2',
      'ubuntu1404' => 'ami-d7fd6ea0',
      'ubuntu1204' => 'ami-6fcb5a18',
      'amazonlinux' => 'ami-ef158898',
    }
  }

  $avz = {
    'us-west-2a' => 'tse-subnet-avza-1',
    'ap-southeast-2a' => 'tse-subnet-avza-1',
    'eu-west-1a' => 'tse-subnet-avza-1',
    'us-west-2b' => 'tse-subnet-avzb-1',
    'ap-southeast-2b' => 'tse-subnet-avzb-1',
    'eu-west-1b' => 'tse-subnet-avzb-1',
  }
}
