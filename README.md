# ubiquitous-waddle

This is an open-source dual channel CAN FD to USB-C adapter. It is meant to be
used with the Zephyr-based [CANnectivity][1] firmware.

## Firmware

### Building

Assuming you already have a working Zephyr development environment (see
[Getting Started Guide][2]), the firmware workspace can be initialized using:
```sh
west init -m "https://github.com/leonwip/ubiquitous-waddle" --mr main my-workspace
cd my-workspace
west update
```

Then to build the release variant (with reduced logging):
```sh
west build -b ubiquitous_waddle --sysbuild cannectivity/app -- -DSB_CONF_FILE=sysbuild-dfu.conf -DFILE_SUFFIX=usbd_next_release
```

### Flashing

To flash via JLink (SWD):
```sh
west flash --runner jlink
```

To flash via USB DFU:
```
dfu-util -a 0 -D build/app/zephyr/zephyr.signed.bin.dfu
```

## Example Usage

Verify successful connection:
```sh
$ lsusb | grep CANnectivity
Bus 005 Device 014: ID 1209:ca01 Generic CANnectivity USB to CAN adapter
```

Determine interface names:
```sh
$ ip link show type can
16: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
    link/can
17: can1: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
    link/can
```

Bring up the interface (with FD on):
```sh
sudo ip link set can0 up type can bitrate 250000 dbitrate 1000000 fd on
```

Send some frames (`##1` opposed to just `#` turns on BRS):
```sh
cansend can0 123#11.22.33
cansend can0 123##111.22.33
```

## License

CANnectivity is licensed under the [Apache-2.0][3] license. This board is
licensed under the [CERN-OHL-P-2.0](./LICENSE) license.

[1]: https://github.com/CANnectivity/cannectivity
[2]: https://docs.zephyrproject.org/latest/develop/getting_started/index.html
[3]: https://github.com/CANnectivity/cannectivity/blob/main/LICENSE
