========================================
Installing Nimble Fuel Plugin for Cinder
========================================

To install the Nimble Cinder plugin, follow these steps:

#. Download it from the `Fuel Plugins Catalog`_.

#. Copy the RPM to the Fuel Master node (if you don't
   have the Fuel Master node, please see `the official
   Mirantis OpenStack documentation`_::

      [root@home ~]# scp cinder_nimble-1.0-1.0.0-1.noarch.rpm root@fuel-master:/tmp

#. Log into Fuel Master node and install the plugin using the `Fuel CLI`_::

      [root@fuel-master ~]# fuel plugins --install cinder_nimble-1.0-1.0.0-1.noarch.rpm

#. Verify that the plugin is installed correctly::

		[root@fuel ~]# fuel plugins --list
		id | name          | version | package_version | releases           
		---+---------------+---------+-----------------+--------------------
		17 | cinder_nimble | 1.0.0   | 4.0.0           | ubuntu (mitaka-9.0)

.. _Fuel Plugins Catalog: https://www.mirantis.com/products/openstack-drivers-and-plugins/fuel-plugins/
.. _the official Mirantis OpenStack documentation: http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-install-guide.html
.. _Fuel CLI: http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/cli.html
