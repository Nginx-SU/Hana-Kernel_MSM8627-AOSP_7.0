# Hana-CoreUX-Kernel_For_Nicki

Hana Core UX Kernel is codename project from Hana Kernel Development. Hana Kernel Development itself have 2 codename in step of development, AoiCore+ and Hana Core UX is still part of Hana Kernel Project. This kernel have main to optimize Xperia M / M Dual device with latest source kernel, many optimization for processor,gpu and much improvement in LMK and KSM manager.

This kernel is include several feature to increase performance and ARM is aim for all improvement, Custom governor and custom I/O Scheduler is already included too here.

This kernel need kernel configuration app to control this kernel, so try to find kernel configuration app after flash this kernel.

This kernel feature is :
- Linux Kernel Version 3.4.11
- Compatibility with AOSP and CM based ROM [Android 6.0+]
- Added overclock up to 1,7Ghz
- Added AutoSMP & Alucard Hotplug
- Added custom CPU Governor 
: Alucard,Intelliactive,IntelliMM,Lionheart,Adaptive,SmartassV2,Intellidemand,HYPER and lulzactive
- Added custom I/O Sched Governor 
: zen,sio,sioplus,tripndroid,fifo,fiops and vr
- Added fast charge feature (Enable By Default)
- Compiled using GCC 5.4.0 Crosstool-NG Toolchains (Optimized for armv7 with neon-vfpv4)
- Add full support NEON VFPV4 feature 
- Enable Graphite optimization on kernel and GPU
- Added Auto hotplug drivers for optimized mpdecision
- Use new hashtable implementation on KSM and HGM
- Update sync from latest cm13 kernel source build 20160909 (For AoiCore+)

More details on changelog for custom build in kernel source

This is kernel tread source
(AoiCore+ Kernel) / v1.6.3 [EOL] {XDA-ONLY}

http://forum.xda-developers.com/xperia-m/orig-development/6-0-aoicore-kernel-t3454265

(HanaCoreUX+ Kernel) V1.2.4 BETA RELEASE:
Non released version (Private)
Download Official build (EXPERIMENTAL) 
https://www.androidfilehost.com/?w=files&flid=120528

(Hana Kernel) Waiting...
Still on development

How to compile kernel from source 

1.Install Ubuntu and Java JDK

2.Install this package on ubuntu
sudo apt-get install -y build-essential kernel-package libncurses5-dev bzip2 bin86 qt4-dev-tools libncurses5 git-core nautilus-open-terminal git-core gnupg flex bison gperf libsdl-dev libesd0-dev libwxgtk2.6-dev zip curl libncurses5-dev zlib1g-dev ia32-libs lib32z1-dev lib32ncurses5-dev gcc-multilib g++-multilib adb 

3.Clone My Customize Crosstool-NG Toolchains 
 git clone https://github.com/Nicklas373/Crosstool-NG-Toolchains-5.4.x_Nicki.git

4.Clone Hana Core UX + Source
 git clone https://github.com/Nicklas373/Hana-CoreUX-Kernel_For_Nicki.git
 
5.After complete, then use this command to compile kernel 
(on HanaCoreUX+ Kernel directory)

export ARCH=arm
export CROSS_COMPILE=(Your Current Toolchains Location)/bin/arm-unknown-linux-gnueabihf-

Compiling,

make ARCH=arm cyanogenmod_nicki_defconfig
make ARCH=arm CROSS_COMPILE=/home/(Your Current Toolchains Location)/bin/arm-unknown-linux-gnueabihf- > hanaLog

Create modules,

mkdir modules
cp arch/arm/boot/zImage modules
find . -name "*.ko" -exec cp {} modules \;

Extracting modules,

cd /home/(Your Current Location)
mkdir Hana_ouput
mv android/kernel/modules Hana_output

Clean before create flashable zip,

cd (Your Kernel Location)
make clean && make mrproper

Create Flashable zip,

extract Hana_Core-UX-nicki.zip
delete all files in system/lib/modules and replace it with your new modules in Hana_output (.ko files)
delete boot.img-zImage in tmp/kernel and replace it with your zImage from Hana_output and rename it too boot.img-zImage
create zip use this command on Hana_Core-UX-nicki directory

zip -r HanaCoreUX+_TEST-nicki

Done “ Hana Core UX + Kernel is ready to flash”
