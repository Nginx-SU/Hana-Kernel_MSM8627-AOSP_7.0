#!/bin/bash
echo "
######################################################
#                                                    #
#           Hana Core UX Kernel Script Builder       #
#                                                    #
#                Nicklas Van Dam @XDA                #
#                                                    #
#	           Royal Patraine		     #
######################################################"

echo "###Cleaning old build"

make clean && make mrproper

echo "
###Extracting Hana Core UX Extension"

cd /home/nicklas
rm Hana_CoreUX-Source/Makefile
cp Hana_CoreUX-EXT/Makefile Hana_CoreUX-Source/Makefile
rm Hana_CoreUX-Source/arch/arm/Kconfig
cp Hana_CoreUX-EXT/arch/arm/Kconfig Hana_CoreUX-Source/arch/arm/Kconfig
rm Hana_CoreUX-Source/arch/arm/Makefile
cp Hana_CoreUX-EXT/arch/arm/Makefile Hana_CoreUX-Source/arch/arm/Makefile
rm Hana_CoreUX-Source/arch/arm/boot/compressed/Makefile
cp Hana_CoreUX-EXT/arch/arm/boot/compressed/Makefile Hana_CoreUX-Source/arch/arm/boot/compressed/Makefile
cp Hana_CoreUX-EXT/arch/arm/configs/hana_core-ux_nicki_defconfig Hana_CoreUX-Source/arch/arm/configs/hana_core-ux_nicki_defconfig
rm Hana_CoreUX-Source/arch/arm/include/asm/xor.h
cp Hana_CoreUX-EXT/arch/arm/include/asm/xor.h Hana_CoreUX-Source/arch/arm/include/asm/xor.h
cp Hana_CoreUX-EXT/arch/arm/include/asm/rwsem.h Hana_CoreUX-Source/arch/arm/include/asm/rwsem.h
rm Hana_CoreUX-Source/arch/arm/kernel/Makefile
cp Hana_CoreUX-EXT/arch/arm/kernel/Makefile Hana_CoreUX-Source/arch/arm/kernel/Makefile
cp Hana_CoreUX-EXT/arch/arm/kernel/auto_hotplug.c Hana_CoreUX-Source/arch/arm/kernel/auto_hotplug.c
cp Hana_CoreUX-EXT/arch/arm/kernel/autosmp.c Hana_CoreUX-Source/arch/arm/kernel/autosmp.c
rm Hana_CoreUX-Source/arch/arm/kernel/head-nommu.S
cp Hana_CoreUX-EXT/arch/arm/kernel/head-nommu.S Hana_CoreUX-Source/arch/arm/kernel/head-nommu.S
rm Hana_CoreUX-Source/arch/arm/kernel/head.S
cp Hana_CoreUX-EXT/arch/arm/kernel/head.S Hana_CoreUX-Source/arch/arm/kernel/head.S
cp Hana_CoreUX-EXT/arch/arm/kernel/hibernate.c Hana_CoreUX-Source/arch/arm/kernel/hibernate.c
rm Hana_CoreUX-Source/arch/arm/lib/Makefile 
cp Hana_CoreUX-EXT/arch/arm/lib/Makefile Hana_CoreUX-Source/arch/arm/lib/Makefile
cp Hana_CoreUX-EXT/arch/arm/lib/xor-neon.c Hana_CoreUX-Source/arch/arm/lib/xor-neon.c
rm Hana_CoreUX-Source/arch/arm/vfp/Makefile
cp Hana_CoreUX-EXT/arch/arm/vfp/Makefile Hana_CoreUX-Source/arch/arm/vfp/Makefile
rm Hana_CoreUX-Source/arch/arm/vfp/vfphw.S
cp Hana_CoreUX-EXT/arch/arm/vfp/vfphw.S Hana_CoreUX-Source/arch/arm/vfp/vfphw.S
rm Hana_CoreUX-Source/arch/arm/vfp/vfpmodule.c
cp Hana_CoreUX-EXT/arch/arm/vfp/vfpmodule.c Hana_CoreUX-Source/arch/arm/vfp/vfpmodule.c
rm Hana_CoreUX-Source/arch/arm/mach-msm/acpuclock-8627.c
cp Hana_CoreUX-EXT/arch/arm/mach-msm/acpuclock-8627.c Hana_CoreUX-Source/arch/arm/mach-msm/acpuclock-8627.c
rm Hana_CoreUX-Source/arch/arm/mach-msm/acpuclock-krait.c
cp Hana_CoreUX-EXT/arch/arm/mach-msm/acpuclock-krait.c Hana_CoreUX-Source/arch/arm/mach-msm/acpuclock-krait.c
cp Hana_CoreUX-EXT/arch/arm/mach-msm/alucard_hotplug.c Hana_CoreUX-Source/arch/arm/mach-msm/alucard_hotplug.c
cp Hana_CoreUX-EXT/arch/arm/mach-msm/cpufreq.c Hana_CoreUX-Source/arch/arm/mach-msm/cpufreq.c
rm Hana_CoreUX-Source/arch/arm/mach-msm/dma_test.c
cp Hana_CoreUX-EXT/arch/arm/mach-msm/dma_test.c Hana_CoreUX-Source/arch/arm/mach-msm/dma_test.c
cp Hana_CoreUX-EXT/arch/arm/mach-msm/fastchg.c Hana_CoreUX-Source/arch/arm/mach-msm/fastchg.c
rm Hana_CoreUX-Source/arch/arm/mach-msm/Kconfig
cp Hana_CoreUX-EXT/arch/arm/mach-msm/Kconfig Hana_CoreUX-Source/arch/arm/mach-msm/Kconfig
rm Hana_CoreUX-Source/arch/arm/mach-msm/Makefile
cp Hana_CoreUX-EXT/arch/arm/mach-msm/Makefile Hana_CoreUX-Source/arch/arm/mach-msm/Makefile
rm Hana_CoreUX-Source/arch/arm/mach-msm/include/mach/kgsl.h
cp Hana_CoreUX-EXT/arch/arm/mach-msm/include/mach/kgsl.h Hana_CoreUX-Source/arch/arm/mach-msm/include/mach/kgsl.h
rm Hana_CoreUX-Source/arch/arm/mach-msm/lge/mako/board-mako.c
cp Hana_CoreUX-EXT/arch/arm/mach-msm/lge/mako/board-mako.c Hana_CoreUX-Source/arch/arm/mach-msm/lge/mako/board-mako.c
rm Hana_CoreUX-Source/block/Kconfig.iosched
cp Hana_CoreUX-EXT/block/Kconfig.iosched Hana_CoreUX-Source/block/Kconfig.iosched
rm Hana_CoreUX-Source/block/Makefile
cp Hana_CoreUX-EXT/block/Makefile Hana_CoreUX-Source/block/Makefile
cp Hana_CoreUX-EXT/block/fifo-iosched.c Hana_CoreUX-Source/block/fifo-iosched.c
cp Hana_CoreUX-EXT/block/fiops-iosched.c Hana_CoreUX-Source/block/fiops-iosched.c
cp Hana_CoreUX-EXT/block/sio-iosched.c Hana_CoreUX-Source/block/sio-iosched.c
cp Hana_CoreUX-EXT/block/sioplus-iosched.c Hana_CoreUX-Source/block/sioplus-iosched.c
cp Hana_CoreUX-EXT/block/tripndroid-iosched.c Hana_CoreUX-Source/block/tripndroid-iosched.c
cp Hana_CoreUX-EXT/block/vr-iosched.c Hana_CoreUX-Source/block/vr-iosched.c
cp Hana_CoreUX-EXT/block/zen-iosched.c Hana_CoreUX-Source/block/zen-iosched.c 
rm Hana_CoreUX-Source/drivers/char/random.c
cp Hana_CoreUX-EXT/drivers/char/random.c Hana_CoreUX-Source/drivers/char/random.c
rm Hana_CoreUX-Source/drivers/cpufreq/Kconfig
cp Hana_CoreUX-EXT/drivers/cpufreq/Kconfig Hana_CoreUX-Source/drivers/cpufreq/Kconfig
rm Hana_CoreUX-Source/drivers/cpufreq/cpufreq.c
cp Hana_CoreUX-EXT/drivers/cpufreq/cpufreq.c Hana_CoreUX-Source/drivers/cpufreq/cpufreq.c
rm Hana_CoreUX-Source/drivers/cpufreq/Makefile
cp Hana_CoreUX-EXT/drivers/cpufreq/Makefile Hana_CoreUX-Source/drivers/cpufreq/Makefile
cp Hana_CoreUX-EXT/drivers/cpufreq/cpufreq_adaptive.c Hana_CoreUX-Source/drivers/cpufreq/cpufreq_adaptive.c
cp Hana_CoreUX-EXT/drivers/cpufreq/cpufreq_alucard.c Hana_CoreUX-Source/drivers/cpufreq/cpufreq_alucard.c
cp Hana_CoreUX-EXT/drivers/cpufreq/cpufreq_HYPER.c Hana_CoreUX-Source/drivers/cpufreq/cpufreq_HYPER.c
cp Hana_CoreUX-EXT/drivers/cpufreq/cpufreq_intellidemand.c Hana_CoreUX-Source/drivers/cpufreq/cpufreq_intellidemand.c
cp Hana_CoreUX-EXT/drivers/cpufreq/cpufreq_intelliactive.c Hana_CoreUX-Source/drivers/cpufreq/cpufreq_intelliactive.cc
cp Hana_CoreUX-EXT/drivers/cpufreq/cpufreq_lionheart.c Hana_CoreUX-Source/drivers/cpufreq/cpufreq_lionheart.c
cp Hana_CoreUX-EXT/drivers/cpufreq/cpufreq_lulzactive.c Hana_CoreUX-Source/drivers/cpufreq/cpufreq_lulzactive.c
cp Hana_CoreUX-EXT/drivers/cpufreq/cpufreq_smartass2.c Hana_CoreUX-Source/drivers/cpufreq/cpufreq_smartass2.c
cp Hana_CoreUX-EXT/drivers/cpufreq/cpufreq_smartmax.c Hana_CoreUX-Source/drivers/cpufreq/cpufreq_smartmax.c
rm Hana_CoreUX-Source/drivers/crypto/msm/qcedev.c
cp Hana_CoreUX-EXT/drivers/crypto/msm/qcedev.c Hana_CoreUX-Source/drivers/crypto/msm/qcedev.c
rm Hana_CoreUX-Source/drivers/gpu/Makefile
cp Hana_CoreUX-EXT/drivers/gpu/Makefile Hana_CoreUX-Source/drivers/gpu/Makefile
rm Hana_CoreUX-Source/drivers/gpu/msm/kgsl_pwrctrl.c
cp Hana_CoreUX-EXT/drivers/gpu/msm/kgsl_pwrctrl.c Hana_CoreUX-Source/drivers/gpu/msm/kgsl_pwrctrl.c
rm Hana_CoreUX-Source/drivers/gpu/ion/Makefile
cp Hana_CoreUX-EXT/drivers/gpu/ion/Makefile Hana_CoreUX-Source/drivers/gpu/ion/Makefile
rm Hana_CoreUX-Source/drivers/gpu/ion/msm/Makefile
cp Hana_CoreUX-EXT/drivers/gpu/ion/msm/Makefile Hana_CoreUX-Source/drivers/gpu/ion/msm/Makefile
rm Hana_CoreUX-Source/drivers/thermal/Kconfig
cp Hana_CoreUX-EXT/drivers/thermal/Kconfig Hana_CoreUX-Source/drivers/thermal/Kconfig
rm Hana_CoreUX-Source/drivers/staging/android/lowmemorykiller.c
cp Hana_CoreUX-EXT/drivers/staging/android/lowmemorykiller.c Hana_CoreUX-Source/drivers/staging/android/lowmemorykiller.c
rm Hana_CoreUX-Source/drivers/usb/otg/msm_otg.c
cp Hana_CoreUX-EXT/drivers/usb/otg/msm_otg.c Hana_CoreUX-Source/drivers/usb/otg/msm_otg.c
rm Hana_CoreUX-Source/drivers/video/cfbimgblt.c
cp Hana_CoreUX-EXT/drivers/video/cfbimgblt.c Hana_CoreUX-Source/drivers/video/cfbimgblt.c
rm Hana_CoreUX-Source/drivers/video/cfbfillrect.c
cp Hana_CoreUX-EXT/drivers/video/cfbfillrect.c Hana_CoreUX-Source/drivers/video/cfbfillrect.c
rm Hana_CoreUX-Source/fs/compat_ioctl.c
cp Hana_CoreUX-EXT/fs/compat_ioctl.c Hana_CoreUX-Source/fs/compat_ioctl.c
rm Hana_CoreUX-Source/include/asm-generic/ioctls.h
cp Hana_CoreUX-EXT/include/asm-generic/ioctls.h Hana_CoreUX-Source/include/asm-generic/ioctls.h
cp Hana_CoreUX-EXT/include/linux/compiler-gcc5.h Hana_CoreUX-Source/include/linux/compiler-gcc5.h
rm Hana_CoreUX-Source/include/linux/cpufreq.h
cp Hana_CoreUX-EXT/include/linux/cpufreq.h Hana_CoreUX-Source/include/linux/cpufreq.h
cp Hana_CoreUX-EXT/include/linux/fastchg.h Hana_CoreUX-Source/include/linux/fastchg.h
cp Hana_CoreUX-EXT/include/linux/suspend.h Hana_CoreUX-Source/include/linux/suspend.h
cp Hana_CoreUX-EXT/include/linux/quickwakeup.h Hana_CoreUX-Source/include/linux/quickwakeup.h
rm Hana_CoreUX-Source/include/trace/events/cpufreq_interactive.h
cp Hana_CoreUX-EXT/include/trace/events/cpufreq_interactive.h Hana_CoreUX-Source/include/trace/events/cpufreq_interactive.h
rm Hana_CoreUX-Source/init/Kconfig
cp Hana_CoreUX-EXT/init/Kconfig Hana_CoreUX-Source/init/Kconfig
rm Hana_CoreUX-Source/kernel/sched/features.h
cp Hana_CoreUX-EXT/kernel/sched/features.h Hana_CoreUX-Source/kernel/sched/features.h
rm Hana_CoreUX-Source/kernel/power/Kconfig
cp Hana_CoreUX-EXT/kernel/power/Kconfig Hana_CoreUX-Source/kernel/power/Kconfig
rm Hana_CoreUX-Source/kernel/power/Makefile
cp Hana_CoreUX-EXT/kernel/power/Makefile Hana_CoreUX-Source/kernel/power/Makefile
cp Hana_CoreUX-EXT/kernel/power/quickwakeup.c Hana_CoreUX-Source/kernel/power/quickwakeup.c
rm Hana_CoreUX-Source/mm/ksm.c
cp Hana_CoreUX-EXT/mm/ksm.c Hana_CoreUX-Source/mm/ksm.c
rm Hana_CoreUX-Source/net/netfilter/Makefile
cp Hana_CoreUX-EXT/net/netfilter/Makefile Hana_CoreUX-Source/net/netfilter/Makefile
cd Hana_CoreUX-Source
echo "
###Running GCC Toolchains 5.4.0 (Crosstool-NG Toolchains)"

export ARCH=arm
export CROSS_COMPILE=/home/nicklas/crosstool-toolchains-5.4.X/bin/arm-unknown-linux-gnueabihf-

echo "
###Building Hana Core UX"

echo "
###Compile kernel process will write on log, for simple interface"

make ARCH=arm hana_core-ux_nicki_defconfig
make ARCH=arm CROSS_COMPILE=/home/nicklas/crosstool-toolchains-5.4.X/bin/arm-unknown-linux-gnueabihf- > Hana-Log

echo "
##Creating Modules kernel"

mkdir modules
cp arch/arm/boot/zImage modules
find . -name "*.ko" -exec cp {} modules \;

echo "
## Preparing Hana Core UX"
cd /home/nicklas
mkdir Hana_ouput
mv Hana_CoreUX-Source/modules Hana_output

echo "##Cleaning Build"
cd Hana_CoreUX-Source
make clean && make mrproper

echo "##Creating Hana_Core_UX-nicki.zip"
cd /home/nicklas/Hana_CoreUX-EXT
./HanaCoreUX_builder.sh

echo "Script Complete Successfuly"
echo "Nicklas Van Dam @ XDA"
echo "Hana Core UX Kernel Finished"
echo "========Royal Patraine======"
