define plugin_cinder_nimble::backend::set_nimble_backend (
  $backend_id,
  $index,
  $cinder_nimble = $plugin_cinder_nimble::params::cinder_nimble,
  $config_file = $plugin_cinder_nimble::params::config_file
) {

  include plugin_cinder_nimble::params
  include cinder::params

  # Set backend details
  # Get the group backend name as configured by the user
  $nimble_group_backend_name    = $cinder_nimble['nimble_group_backend_name']

  # Sets correct driver depending on backend protocol
  if ($cinder_nimble["nimble${backend_id}_backend_protocol"]) == 'iSCSI' {
    if ! defined(Package['open-iscsi']) {
      # We need following packages to create a root volume during an instance spawning
      package { 'open-iscsi': }
    }
    $nimble_cinder_driver = 'cinder.volume.drivers.nimble.NimbleISCSIDriver'
  }
  elsif ($cinder_nimble["nimble${backend_id}_backend_protocol"]) == 'FC' {
    $nimble_cinder_driver = 'cinder.volume.drivers.nimble.NimbleFCDriver'
  }

  # To be ensure that $ symbol is correctly escaped in cinder password
  $nimble_password = regsubst($cinder_nimble["nimble${backend_id}_password"],'\$','$$','G')

  # Check whether grouping is enabled and adjust volume_backend_name accordingly
  if ($cinder_nimble['nimble_grouping']) == true {
    if ($cinder_nimble["nimble${backend_id}_cinder_service_name"]) != '' {
      $nimble_backend_name = $cinder_nimble["nimble${backend_id}_cinder_service_name"]
    }
    else {
      $nimble_backend_name = "${nimble_group_backend_name}_${backend_id}"
    }
    $nimble_volume_backend_name = "${nimble_group_backend_name}"
  }
  else {
    if ($cinder_nimble["nimble${backend_id}_cinder_service_name"]) != '' {
      $nimble_backend_name = $cinder_nimble["nimble${backend_id}_cinder_service_name"]
    }
    else {
      $nimble_backend_name = "${cinder_nimble["nimble${backend_id}_backend_name"]}"
    }
    $nimble_volume_backend_name = "${cinder_nimble["nimble${backend_id}_backend_name"]}"
  }
  # Pool name selection
  if ($cinder_nimble["nimble${backend_id}_pool_name"]) != '' {
    $nimble_pool_name = $cinder_nimble["nimble${backend_id}_pool_name"]
  }
  else {
    $nimble_pool_name = 'default'
  }

  Cinder_config <||> -> Plugin_cinder_nimble::Backend::Enable_backend[$nimble_backend_name] ~> Service <||>
  Cinder_config <||> ~> Service <||>

  cinder_config {
    "$nimble_backend_name/volume_backend_name":             value => $nimble_volume_backend_name;
    "$nimble_backend_name/volume_driver":                   value => $nimble_cinder_driver;
    "$nimble_backend_name/san_ip":                          value => $cinder_nimble["nimble${backend_id}_san_ip"];
    "$nimble_backend_name/san_login":                       value => $cinder_nimble["nimble${backend_id}_login"];
    "$nimble_backend_name/san_password":                    value => $nimble_password;
    "$nimble_backend_name/nimble_pool_name":                value => $nimble_pool_name;
    "$nimble_backend_name/use_multipath_for_image_xfer":    value => $cinder_nimble["nimble${backend_id}_mp_img_xfer"];
  }

  # nimble_subnet_label enabled only when iSCSI and non-nil!
  if (($cinder_nimble["nimble${backend_id}_subnet_label"]) != '') and (($cinder_nimble["nimble${backend_id}_backend_protocol"]) == 'iSCSI'){
    cinder_config { "$nimble_backend_name/nimble_subnet_label":
      value => $cinder_nimble["nimble${backend_id}_subnet_label"],
    }
  }
  else {
    cinder_config { "$nimble_backend_name/nimble_subnet_label":
      ensure => absent,
    }
  }

  # Adds the backend in <enabled_backends> parameter
  plugin_cinder_nimble::backend::enable_backend { $nimble_backend_name: }
}
