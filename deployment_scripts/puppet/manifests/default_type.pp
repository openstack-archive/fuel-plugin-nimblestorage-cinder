notice('MODULAR: nimble-default-volume-type')

$config_file = '/etc/cinder/cinder.conf'
$cinder_nimble = hiera_hash('cinder_nimble', {})

define plugin_cinder_nimble::check_if_default_backend_is_enabled (
) {
  if ($cinder_nimble["nimble${name}_default_backend"]) == true {
    class { 'plugin_cinder_nimble::backend::set_default_type' :
      config_file => $config_file,
      nimble_backend_type => $cinder_nimble["nimble${name}_backend_type"],
    }
  }
}

if ($cinder_nimble['nimble_grouping']) == true {
  if ($cinder_nimble["nimble_group_default_backend"]) == true {
    class { 'plugin_cinder_nimble::backend::set_default_type' :
      config_file => $config_file,
      nimble_backend_type => $cinder_nimble['nimble_group_backend_type'],
    }
  }
}
else {
  # Should work from Puppet >= 4.0.0 onwards which has Future parser
  /*
  range("1", "$cinder_nimble['no_backends']").each |Integer $index, String $value| {
    if ($cinder_nimble["nimble${value}_default_backend"]) == true {
      $nimble_default_type = $cinder_nimble["nimble${value}_backend_type"]
      $nimble_default_type_set = true
    }
  }
  */

  $range_array = range("1", $cinder_nimble['no_backends'])
  plugin_cinder_nimble::check_if_default_backend_is_enabled { $range_array: }
}
