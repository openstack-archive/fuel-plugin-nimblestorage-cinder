notice('MODULAR: nimble-default-volume-type')

$config_file = '/etc/cinder/cinder.conf'
$cinder_nimble = hiera_hash('cinder_nimble', {})

if ($cinder_nimble['nimble_grouping']) == true {
  $nimble_default_type_set = $cinder_nimble['nimble_group_default_backend']
  $nimble_default_type = $cinder_nimble['nimble_group_backend_type']
}
else {
  $nimble_default_type_set = $cinder_nimble['nimble1_default_backend'] or
                             $cinder_nimble['nimble2_default_backend'] or
                             $cinder_nimble['nimble3_default_backend'] or
                             $cinder_nimble['nimble4_default_backend'] or
                             $cinder_nimble['nimble5_default_backend']
  if ($cinder_nimble['nimble1_default_backend']) == true {
    $nimble_default_type = $cinder_nimble['nimble1_backend_type']
  }
  elsif ($cinder_nimble['nimble2_default_backend']) == true {
    $nimble_default_type = $cinder_nimble['nimble2_backend_type']
  }
  elsif ($cinder_nimble['nimble3_default_backend']) == true {
    $nimble_default_type = $cinder_nimble['nimble3_backend_type']
  }
  elsif ($cinder_nimble['nimble4_default_backend']) == true {
    $nimble_default_type = $cinder_nimble['nimble4_backend_type']
  }
  elsif ($cinder_nimble['nimble5_default_backend']) == true {
    $nimble_default_type = $cinder_nimble['nimble5_backend_type']
  }
}

class { 'plugin_cinder_nimble::backend::set_default_type' :
  config_file => $config_file,
  nimble_default_type_set => $nimble_default_type_set,
  nimble_backend_type => $nimble_default_type,
}
