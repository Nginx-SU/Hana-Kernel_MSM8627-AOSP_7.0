![Hana Kernel Logo](https://img.xda-cdn.com/obVtyoToPS7po1U_8_SC-2ZWILQ=/https%3A%2F%2Flh3.googleusercontent.com%2FdJ6gvVjERqxce4UD7hTgmdjKNVNMDjiCrOtzvjm8pSsBOVRUAsuvpK4cKnIz3MEIpJTV6OeEoA%3Dw1366-h768-rw-no)

# Hana Kernel For Xperia M / M Dual

Hana Kernel Development. Hana kernel based on AOSP Nougat source, and included many improvement and optimization on processor,gpu and include some feature for Xperia M / M dual devices that use Marshmallow as base ROM.

Hana offered kernel stability, smoothness process on cpu and already have full support on NEON-vfpv4.
This kernel is include several feature to increase performance and ARM is aim for all improvement, Custom governor and custom I/O Scheduler is already included too here.

This kernel need kernel configuration app to control this kernel, so try to find kernel configuration app after flash this kernel.

This kernel feature is :
- Linux Kernel Version 3.4.17
- Compatibility with AOSP and CM based ROM [Android 6.0+]
- Added overclock up to 1,7Ghz
- Added Double Tap 2 Wake Feature
- Added CPU Voltage Control
- Added Overclocked GPU to 500Mhz
- Added Auto Reboot feature when hold power button
- Added Alucard & AutoSMP Hotplug Manager
- Added custom CPU Governor 
- = Alucard,Intelliactive,IntelliMM,Lionheart,Adaptive,SmartassV2,HYPER,Cyan & Bioshock
- Added custom I/O Sched Governor 
- = zen,sio,sioplus,tripndroid,fifo,fiops and vr
- Added fast charge feature (Enable By Default)
- Compiled using GCC 5.4.0 Crosstool-NG Toolchains (Optimized for armv7 with neon-vfpv4)
- Add full support NEON VFPV4 feature 
- Enable Graphite optimization on kernel and GPU
- Enable ARM Hibernation function
- Improved "get cpu idle time" on stock governor
- Updated I/O Sched default list
- Use new hashtable implementation on KSM and HGM
- Sync from latest AOSP Source 20161220

More details on changelog for custom build in kernel source

Hana Kernel XDA Thread
http://forum.xda-developers.com/xperia-m/orig-development/6-0-aoicore-kernel-t3454265

(Hana Kernel) V1.2.4 STABLE RELEASE
Pre Released Version (Private)
Download Official build (EXPERIMENTAL) 
https://www.androidfilehost.com/?fid=745425885120696011

(HanaCoreUX+ Kernel) V1.2.7 Pre STABLE RELEASE
[EOL]
Non released version (Private)
Download Official build (EXPERIMENTAL) 
https://www.androidfilehost.com/?w=files&flid=120528

(AoiCore+ Kernel) / v1.6.3 
[EOL] {XDA-ONLY}
http://forum.xda-developers.com/devdb/project/?id=16883#downloads

Thanks to :
Ron Gokhale (@PecanCM) [For Kernel Source]
Alex Rivero (@Alex_Gamer) [Kernel Tester & Troubleshoot]
Ngxson (@thichthat) [For DT2W Source]

# Hana Kernel | Makihatayama Hana (2016)
