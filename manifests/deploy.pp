class tse_awsnodes::deploy {
  if $::ec2_instance_id {
    notify { 'deploying aws nodes': }
    class { 'tse_awsnodes': }
  }
}
