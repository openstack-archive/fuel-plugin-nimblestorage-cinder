# Since Fuel 8.0 has its own task to set Cinder volume-types. We add our modifications before this task is executed.

notice('MODULAR: nimble-hiera-override')

$cinder_nimble   = hiera_hash('cinder_nimble', {})
$nimble_group_backend_type    = $cinder_nimble['nimble_group_backend_type']
$nimble_group_backend_name    = $cinder_nimble['nimble_group_backend_name']
$no_backends             = $cinder_nimble['no_backends']
$nimble1_backend_type    = $cinder_nimble['nimble1_backend_type']
$nimble1_backend_name    = $cinder_nimble['nimble1_backend_name']
$nimble2_backend_type    = $cinder_nimble['nimble2_backend_type']
$nimble2_backend_name    = $cinder_nimble['nimble2_backend_name']

$hiera_dir    = '/etc/hiera/plugins'
$plugin_yaml  = 'cinder_nimble.yaml'
$plugin_name  = 'cinder_nimble'

# extraspecs
$nimble_group_encryption      = $cinder_nimble['nimble_group_encryption']
$nimble_group_perfpol         = $cinder_nimble['nimble_group_perfpol']
$nimble_group_multi_init      = $cinder_nimble['nimble_group_multi_init']
$nimble1_encryption      = $cinder_nimble['nimble1_encryption']
$nimble1_perfpol         = $cinder_nimble['nimble1_perfpol']
$nimble1_multi_init      = $cinder_nimble['nimble1_multi_init']
$nimble2_encryption      = $cinder_nimble['nimble2_encryption']
$nimble2_perfpol         = $cinder_nimble['nimble2_perfpol']
$nimble2_multi_init      = $cinder_nimble['nimble2_multi_init']

file { $hiera_dir:
  ensure => directory,
}

# Create content based on grouping flag.
# This is separated to keep the inline content and conditions tidy.
if ($cinder_nimble['nimble_grouping']) == true {
$content = inline_template('
storage:
  volume_backend_names:
    <%= nimble_group_backend_type %>: <%= nimble_group_backend_name %>
  nimble_encryption:
    <%= nimble_group_backend_type %>: <%= nimble_group_encryption -%>
<% if nimble_group_perfpol != "" %>
  nimble_perfpol:
    <%= nimble_group_backend_type %>: <%= nimble_group_perfpol -%>
<% end %>
  nimble_multi_init:
    <%= nimble_group_backend_type %>: <%= nimble_group_multi_init %>
')
}
else {
$content = inline_template('
storage:
  volume_backend_names:
    <%= nimble1_backend_type %>: <%= nimble1_backend_name -%>
<% if no_backends != "1" %>
    <%= nimble2_backend_type %>: <%= nimble2_backend_name -%>
<% end %>
  nimble_encryption:
    <%= nimble1_backend_type %>: <%= nimble1_encryption -%>
<% if no_backends != "1" %>
    <%= nimble2_backend_type %>: <%= nimble2_encryption -%>
<% end -%>
<% if nimble1_perfpol != "" or nimble2_perfpol != "" %>
  nimble_perfpol:
<% if nimble1_perfpol != "" -%>
    <%= nimble1_backend_type %>: <%= nimble1_perfpol -%>
<% end %>
<% if no_backends != "1" and nimble2_perfpol != "" -%>
    <%= nimble2_backend_type %>: <%= nimble2_perfpol -%>
<% end %>
<% end %>
  nimble_multi_init:
    <%= nimble1_backend_type %>: <%= nimble1_multi_init -%>
<% if no_backends != "1" %>
    <%= nimble2_backend_type %>: <%= nimble2_multi_init -%>
<% end %>
')
}

file { "${hiera_dir}/${plugin_yaml}":
  ensure  => file,
  content => $content,
}

# Workaround for bug 1598163
exec { 'patch_puppet_bug_1598163':
  path    => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin',
  cwd     => '/etc/puppet/modules/osnailyfacter/manifests/globals',
  command => "sed -i \"s/hiera('storage/hiera_hash('storage/\" globals.pp",
  onlyif  => "grep \"hiera('storage\" globals.pp"
}
