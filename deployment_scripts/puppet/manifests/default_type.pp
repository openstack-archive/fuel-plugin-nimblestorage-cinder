notice('MODULAR: nimble-default-volume-type')

$config_file = '/etc/cinder/cinder.conf'
$cinder_nimble = hiera_hash('cinder_nimble', {})

if ($cinder_nimble['nimble_grouping']) == true {
  if (($cinder_nimble['nimble_group_default_backend']) == true) and
      (($cinder_nimble['nimble_group_backend_type']) != '') {
    class { 'plugin_cinder_nimble::backend::set_default_type' :
      config_file         => $config_file,
      nimble_backend_type => $cinder_nimble['nimble_group_backend_type'],
    }
  }
}
else {
  $range_array = range('1', $cinder_nimble['no_backends'])
  plugin_cinder_nimble::backend::check_if_default_type_is_enabled { $range_array:
    enable        => true,
    cinder_nimble => $cinder_nimble,
    config_file   => $config_file
  }
}
