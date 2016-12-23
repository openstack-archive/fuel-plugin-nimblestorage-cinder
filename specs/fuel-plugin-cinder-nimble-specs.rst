..
 This work is licensed under the Apache License, Version 2.0.

 http://www.apache.org/licenses/LICENSE-2.0


===========================================
Nimble Fuel Plugin for Cinder specification
===========================================

Overview
========

The Nimble Fuel plugin for Cinder extends the Mirantis OpenStack capability by providing support for the Nimble Cinder Driver to enable Nimble arrays to be used for the Cinder backends. The plugin for MOS 9.x will support the iSCSI protocol for the Nimble Driver for the communication between the OpenStack cluster(s) and the Nimble Storage array. The plugin also allows users to define multiple backends, define a default volume type, and integrates with the features of the Nimble Storage array. 

This repo contains all necessary files to build the Nimble Fuel Plugin for Cinder, as well as documentation that will provide information on how to use the plugin. 


Problem description
===================

There is currently no support for Nimble Storage arrays as block storage with MOS 9.0 to enable the configuration of Nimble backends via the Fuel deployment ecosystem. This Nimble integration can now be implemented as a plugin for Fuel. This plugin also leverages the Fuel plugin Hot-Pluggable architecture. Thus, enabling the ability to provision cinder backends after the initial MOS deployment. 

The plugin will support all of the Nimble Storage arrays and it's Nimble OS. It will also support the capabilities of the Nimble Cinder driver as of MOS 9.x. 


Proposed Change
===============

Implement a Fuel plugin that will configure the Nimble Storage Cinder driver on all controller nodes. The cinder.conf file will contain the necessary backend definitions to support the use of Nimble Storage arryas, As well as enable specific volume types with the appropriate extra-specs that are supported by the Nimble cinder driver. 
The plugin will also be Hot-Pluggable so that subsequent Cinder backends can be configured and deployed based upon requirements. 
 
The plugin will create the appropriate definitions within the cinder.conf, enable the appropriate backends, define the default volume type (if configured), and create the necessary volume type and their associated extra-specs based on the definition of the backend(s). 


Example multi-backend configuration
===================================

Below is an example of a cinder.conf file for a multi-backend deployment for Nimble Storage using the Fuel plugin:

        **enabled_backends = LVM-backend,nimblea,nimblec,nimbleb**



        **[nimblea]**

        san_ip=10.18.128.190

        volume_driver=cinder.volume.drivers.nimble.NimbleISCSIDriver
        
        san_password=
	
        volume_backend_name=nimblea
	
        nimble_pool_name=default
	
        use_multipath_for_image_xfer=True
	
        san_login=admin



        **[nimbleb]**
	
        san_password=
	
        nimble_pool_name=default
	
        san_ip=10.18.128.67
	
        nimble_subnet_label=iSCSI-B
	
        volume_driver=cinder.volume.drivers.nimble.NimbleISCSIDriver
	
        use_multipath_for_image_xfer=True
	
        volume_backend_name=nimbleb
	
        san_login=admin



        **[nimblec]**
	
        san_login=admin
	
        nimble_pool_name=default
	
        volume_backend_name=nimblec
	
        volume_driver=cinder.volume.drivers.nimble.NimbleISCSIDriver
	
        san_ip=10.18.128.60
	
        use_multipath_for_image_xfer=True
        
        nimble_subnet_label=iSCSI-B
	
        san_password=


For more information on the configuration options for the Nimble Cinder driver made available with the Fuel Plugin, please see `Cinder Nimble Driver configuration <http://docs.openstack.org/mitaka/config-reference/block-storage/drivers/nimble-volume-driver.html>`_



REST API impact
===============
* None.

Upgrade impact
==============
* None

Security impact
===============
* None

Notifications impact
====================
* None.

Other end user impact
=====================
* None.

Plugin impact
=============
* This plugin should not impact other plugins as it does not alter the same configurables as other plugins or storage provider definitions.

Other deployer impact
=====================
* None

Developer impact
================
* None

Documentation Impact
====================
* Reference to this plugin should be added to main Fuel documentation.

Implementation
==============
The plugin will create the proper cinder.conf stanzas to enable the Nimble Stotrage array backend configuration for the Nimble Cinder driver. 
There are not any other packages or Nimble SDK's required. The Nimble Cinder driver is part of the upstream release of OpenStack, and
is included in the Mirantis Openstack dsitribution. 

Work Items
----------

* Develop specs for the the Nimble Fuel Plugin for Cinder
* Develop and implement the Fuel plugin
* Develop and Implement the necessary Puppet manaifests.
* Unit and system testing based on Use cases
* Complete necessary documentation and User's Guide

Dependencies
============

* Fuel 9.0 and higher

Testing
=======

* Create and validate test plan based on Fuel plugin specifications with Nimble Cinder Driver
* Test the Nimble Plugin with various deployment scenarios
* Plugin should pass all tests executed manually

Documentation Impact
====================

* Reference to this plugin should be added to main Fuel documentation.
* Plugin User Guide
* Test Plan
* Test Report
* Test demo/recording


Alternatives
============

* The steps required to configure the Nimble Cinder driver and it's Cinder backends can be performed manually.