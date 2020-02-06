# ExoHome Pro IoT Connector Template

## What it is

This repository included a iot connector template. 

The iot connector created by this template will be able to connect ExoHome devices to ExoSense and ExoHome simultaneously without changing any firmware code.

## Supported features

* Convert ExoHome data-in to ExoSense data-in, so users can have dashboard in ExoSense for the device. 
* Convert ExoHome channel data to ExoSense config_io (locked, can not modify in ExoSense UI.)
* Able to control device from ExoSense ControlPanel. 

## Limitations / Todos

* Only support number channel. (Because current ExoHome real cases are only use number type)

## How to use

1. Create an iot connector from this template. 
2. Link the iot connector to ExoHome solution. 
3. Link the iot connector to ExoSense solution. 
4. Add ExoHome device to the iot connector, and claim the device in ExoSense.
5. The ExoHome device should report "fields" resource, then ExoSense will see the config_io automatically. (Dynamically generated while ExoSense call Device2.listIdentities and other related APIs)
6. Create assets and dashboards in the ExoSense from the device. 
7. When the device report data (with ExoHome protocol), the ExoHome & ExoSense should see same reported value.
