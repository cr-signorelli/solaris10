# Update ILOM by CLI



```console
-> load -source http://10.1.2.166:8888/Sun_System_Firmware-9_8_5_c-SPARC_T7-2.pkg

NOTE: An upgrade takes several minutes to complete. ILOM
      will enter a special mode to load new firmware. No
      other tasks can be performed in ILOM until the
      firmware upgrade is complete and ILOM is reset.

Are you sure you want to load the specified file (y/n)? y
Preserve existing configuration (y/n)? y
...............................................................................................................................................................................................................................................................................................................................................................

Firmware update is complete.
ILOM will now be restarted with the new firmware.

-> /sbin/reboot
```
