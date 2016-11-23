class plugin_cinder_nimble::backend::nimble (
  $cinder_nimble          = $plugin_cinder_nimble::params::cinder_nimble
) {

  include plugin_cinder_nimble::params
  include cinder::params

  # Get the group backend name as configured by the user
  $nimble_group_backend_name    = $cinder_nimble['nimble_group_backend_name'] 

  # Sets correct driver depending on backend protocol
  if ($cinder_nimble['nimble1_backend_protocol']) == 'iSCSI' {
    if ! defined(Package['open-iscsi']) {
      # We need following packages to create a root volume during an instance spawning
      package { 'open-iscsi': }
    }
    $nimble1_cinder_driver = 'cinder.volume.drivers.nimble.NimbleISCSIDriver' 
  }
  elsif ($cinder_nimble['nimble1_backend_protocol']) == 'FC' {
    $nimble1_cinder_driver = 'cinder.volume.drivers.nimble.NimbleFCDriver' 
  }

  # To be ensure that $ symbol is correctly escaped in cinder password
  $nimble1_password = regsubst($cinder_nimble['nimble1_password'],'\$','$$','G')

  # Check whether grouping is enabled and adjust volume_backend_name accordingly 
  if ($cinder_nimble['nimble_grouping']) == true {
    $nimble1_backend_name = "${nimble_group_backend_name}_1"
    $nimble1_volume_backend_name = "${nimble_group_backend_name}"
  }
  else {
    $nimble1_backend_name = "${cinder_nimble['nimble1_backend_name']}"
    $nimble1_volume_backend_name = "${cinder_nimble['nimble1_backend_name']}"
  }

  Cinder_config <||> -> Plugin_cinder_nimble::Backend::Enable_backend[$nimble1_backend_name] ~> Service <||>
  Cinder_config <||> ~> Service <||>

  cinder_config {
    "$nimble1_backend_name/volume_backend_name":             value => $nimble1_volume_backend_name;
    "$nimble1_backend_name/volume_driver":                   value => $nimble1_cinder_driver;
    "$nimble1_backend_name/san_ip":                          value => $cinder_nimble['nimble1_san_ip'];
    "$nimble1_backend_name/san_login":                       value => $cinder_nimble['nimble1_login'];
    "$nimble1_backend_name/san_password":                    value => $nimble1_password;
  }

  # Adds the backend in <enabled_backends> parameter
  plugin_cinder_nimble::backend::enable_backend { $nimble1_backend_name: }

  if ($cinder_nimble['no_backends']) >= '2' {
    # Sets correct driver depending on backend protocol
    if ($cinder_nimble['nimble2_backend_protocol']) == 'iSCSI' {
      if ! defined(Package['open-iscsi']) {
        # We need following packages to create a root volume during an instance spawning
        package { 'open-iscsi': }
      }
      $nimble2_cinder_driver = 'cinder.volume.drivers.nimble.NimbleISCSIDriver'
    }
    elsif ($cinder_nimble['nimble2_backend_protocol']) == 'FC' {
      $nimble2_cinder_driver = 'cinder.volume.drivers.nimble.NimbleFCDriver'
    }

    # To be ensure that $ symbol is correctly escaped in cinder password
    $nimble2_password = regsubst($cinder_nimble['nimble2_password'],'\$','$$','G')

    # Check whether grouping is enabled and adjust volume_backend_name accordingly
    if ($cinder_nimble['nimble_grouping']) == true {
      $nimble2_backend_name = "${nimble_group_backend_name}_2"
      $nimble2_volume_backend_name = "${nimble_group_backend_name}"
    }
    else {
      $nimble2_backend_name = "${cinder_nimble['nimble2_backend_name']}" 
      $nimble2_volume_backend_name = "${cinder_nimble['nimble2_backend_name']}"
    }

    Cinder_config <||> -> Plugin_cinder_nimble::Backend::Enable_backend[$nimble2_backend_name] ~> Service <||>
    Cinder_config <||> ~> Service <||>

    cinder_config {
      "$nimble2_backend_name/volume_backend_name":             value => $nimble2_volume_backend_name;
      "$nimble2_backend_name/volume_driver":                   value => $nimble2_cinder_driver;
      "$nimble2_backend_name/san_ip":                          value => $cinder_nimble['nimble2_san_ip'];
      "$nimble2_backend_name/san_login":                       value => $cinder_nimble['nimble2_login'];
      "$nimble2_backend_name/san_password":                    value => $nimble2_password;
    }

    # Adds the backend in <enabled_backends> parameter
    plugin_cinder_nimble::backend::enable_backend { $nimble2_backend_name: }
  }	

  service { $cinder::params::volume_service: }
}
