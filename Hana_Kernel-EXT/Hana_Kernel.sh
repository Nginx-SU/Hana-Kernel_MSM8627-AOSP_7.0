#!/bin/bash
echo "
######################################################
#                                                    #
#             Hana Kernel Script Builder             #
#                                                    #
#                Nicklas Van Dam @XDA                #
#                                                    #
#	           Royal Patraine		     #
######################################################"

echo "###Cleaning old build"

make clean && make mrproper

echo "
###Extracting Hana Kernel Extension"

cd /home/nicklas
rm Hana_Kernel-Source/Makefile
cp Hana_Kernel-EXT/Makefile Hana_Kernel-Source/Makefile
rm Hana_Kernel-Source/arch/arm/Kconfig
cp Hana_Kernel-EXT/arch/arm/Kconfig Hana_Kernel-Source/arch/arm/Kconfig
rm Hana_Kernel-Source/arch/arm/Makefile
cp Hana_Kernel-EXT/arch/arm/Makefile Hana_Kernel-Source/arch/arm/Makefile
rm Hana_Kernel-Source/arch/arm/boot/compressed/Makefile
cp Hana_Kernel-EXT/arch/arm/boot/compressed/Makefile Hana_Kernel-Source/arch/arm/boot/compressed/Makefile
cp Hana_Kernel-EXT/arch/arm/configs/hana_kernel_nicki_defconfig Hana_Kernel-Source/arch/arm/configs/hana_kernel_nicki_defconfig
rm Hana_Kernel-Source/arch/arm/include/asm/xor.h
cp Hana_Kernel-EXT/arch/arm/include/asm/xor.h Hana_Kernel-Source/arch/arm/include/asm/xor.h
cp Hana_Kernel-EXT/arch/arm/include/asm/rwsem.h Hana_Kernel-Source/arch/arm/include/asm/rwsem.h
rm Hana_Kernel-Source/arch/arm/kernel/Makefile
cp Hana_Kernel-EXT/arch/arm/kernel/Makefile Hana_Kernel-Source/arch/arm/kernel/Makefile
cp Hana_Kernel-EXT/arch/arm/kernel/auto_hotplug.c Hana_Kernel-Source/arch/arm/kernel/auto_hotplug.c
cp Hana_Kernel-EXT/arch/arm/kernel/autosmp.c Hana_Kernel-Source/arch/arm/kernel/autosmp.c
rm Hana_Kernel-Source/arch/arm/kernel/head-nommu.S
cp Hana_Kernel-EXT/arch/arm/kernel/head-nommu.S Hana_Kernel-Source/arch/arm/kernel/head-nommu.S
rm Hana_Kernel-Source/arch/arm/kernel/head.S
cp Hana_Kernel-EXT/arch/arm/kernel/head.S Hana_Kernel-Source/arch/arm/kernel/head.S
cp Hana_Kernel-EXT/arch/arm/kernel/hibernate.c Hana_Kernel-Source/arch/arm/kernel/hibernate.c
rm Hana_Kernel-Source/arch/arm/lib/Makefile 
cp Hana_Kernel-EXT/arch/arm/lib/Makefile Hana_Kernel-Source/arch/arm/lib/Makefile
cp Hana_Kernel-EXT/arch/arm/lib/xor-neon.c Hana_Kernel-Source/arch/arm/lib/xor-neon.c
rm Hana_Kernel-Source/arch/arm/vfp/Makefile
cp Hana_Kernel-EXT/arch/arm/vfp/Makefile Hana_Kernel-Source/arch/arm/vfp/Makefile
rm Hana_Kernel-Source/arch/arm/vfp/vfphw.S
cp Hana_Kernel-EXT/arch/arm/vfp/vfphw.S Hana_Kernel-Source/arch/arm/vfp/vfphw.S
rm Hana_Kernel-Source/arch/arm/vfp/vfpmodule.c
cp Hana_Kernel-EXT/arch/arm/vfp/vfpmodule.c Hana_Kernel-Source/arch/arm/vfp/vfpmodule.c
rm Hana_Kernel-Source/arch/arm/mach-msm/acpuclock-8627.c
cp Hana_Kernel-EXT/arch/arm/mach-msm/acpuclock-8627.c Hana_Kernel-Source/arch/arm/mach-msm/acpuclock-8627.c
rm Hana_Kernel-Source/arch/arm/mach-msm/acpuclock-krait.c
cp Hana_Kernel-EXT/arch/arm/mach-msm/acpuclock-krait.c Hana_Kernel-Source/arch/arm/mach-msm/acpuclock-krait.c
cp Hana_Kernel-EXT/arch/arm/mach-msm/alucard_hotplug.c Hana_Kernel-Source/arch/arm/mach-msm/alucard_hotplug.c
rm Hana_Kernel-Source/arch/arm/mach-msm/board-8930-gpu.c
cp Hana_Kernel-EXT/arch/arm/mach-msm/board-8930-gpu.c Hana_Kernel-Source/arch/arm/mach-msm/board-8930-gpu.c
rm Hana_Kernel-Source/arch/arm/mach-msm/board-8930-regulator-pm8038.c
cp Hana_Kernel-EXT/arch/arm/mach-msm/board-8930-regulator-pm8038.c Hana_Kernel-Source/arch/arm/mach-msm/board-8930-regulator-pm8038.c
rm Hana_Kernel-Source/arch/arm/mach-msm/clock-8960.c
cp Hana_Kernel-EXT/arch/arm/mach-msm/clock-8960.c Hana_Kernel-Source/arch/arm/mach-msm/clock-8960.c
rm Hana_Kernel-Source/arch/arm/mach-msm/cpufreq.c
cp Hana_Kernel-EXT/arch/arm/mach-msm/cpufreq.c Hana_Kernel-Source/arch/arm/mach-msm/cpufreq.c
rm Hana_Kernel-Source/arch/arm/mach-msm/devices-8960.c
cp Hana_Kernel-EXT/arch/arm/mach-msm/devices-8960.c Hana_Kernel-Source/arch/arm/mach-msm/devices-8960.c
rm Hana_Kernel-Source/arch/arm/mach-msm/dma_test.c
cp Hana_Kernel-EXT/arch/arm/mach-msm/dma_test.c Hana_Kernel-Source/arch/arm/mach-msm/dma_test.c
cp Hana_Kernel-EXT/arch/arm/mach-msm/fastchg.c Hana_Kernel-Source/arch/arm/mach-msm/fastchg.c
rm Hana_Kernel-Source/arch/arm/mach-msm/Kconfig
cp Hana_Kernel-EXT/arch/arm/mach-msm/Kconfig Hana_Kernel-Source/arch/arm/mach-msm/Kconfig
rm Hana_Kernel-Source/arch/arm/mach-msm/Makefile
cp Hana_Kernel-EXT/arch/arm/mach-msm/Makefile Hana_Kernel-Source/arch/arm/mach-msm/Makefile
rm Hana_Kernel-Source/block/Kconfig.iosched
cp Hana_Kernel-EXT/block/Kconfig.iosched Hana_Kernel-Source/block/Kconfig.iosched
rm Hana_Kernel-Source/block/Makefile
cp Hana_Kernel-EXT/block/Makefile Hana_Kernel-Source/block/Makefile
cp Hana_Kernel-EXT/block/fifo-iosched.c Hana_Kernel-Source/block/fifo-iosched.c
cp Hana_Kernel-EXT/block/fiops-iosched.c Hana_Kernel-Source/block/fiops-iosched.c
cp Hana_Kernel-EXT/block/sio-iosched.c Hana_Kernel-Source/block/sio-iosched.c
cp Hana_Kernel-EXT/block/sioplus-iosched.c Hana_Kernel-Source/block/sioplus-iosched.c
cp Hana_Kernel-EXT/block/tripndroid-iosched.c Hana_Kernel-Source/block/tripndroid-iosched.c
cp Hana_Kernel-EXT/block/vr-iosched.c Hana_Kernel-Source/block/vr-iosched.c
cp Hana_Kernel-EXT/block/zen-iosched.c Hana_Kernel-Source/block/zen-iosched.c 
rm Hana_Kernel-Source/drivers/char/random.c
cp Hana_Kernel-EXT/drivers/char/random.c Hana_Kernel-Source/drivers/char/random.c
rm Hana_Kernel-Source/drivers/cpufreq/Kconfig
cp Hana_Kernel-EXT/drivers/cpufreq/Kconfig Hana_Kernel-Source/drivers/cpufreq/Kconfig
rm Hana_Kernel-Source/drivers/cpufreq/cpufreq.c
cp Hana_Kernel-EXT/drivers/cpufreq/cpufreq.c Hana_Kernel-Source/drivers/cpufreq/cpufreq.c
rm Hana_Kernel-Source/drivers/cpufreq/Makefile
cp Hana_Kernel-EXT/drivers/cpufreq/Makefile Hana_Kernel-Source/drivers/cpufreq/Makefile
cp Hana_Kernel-EXT/drivers/cpufreq/cpufreq_adaptive.c Hana_Kernel-Source/drivers/cpufreq/cpufreq_adaptive.c
cp Hana_Kernel-EXT/drivers/cpufreq/cpufreq_alucard.c Hana_Kernel-Source/drivers/cpufreq/cpufreq_alucard.c
cp Hana_Kernel-EXT/drivers/cpufreq/cpufreq_intelliactive.c Hana_Kernel-Source/drivers/cpufreq/cpufreq_intelliactive.c
cp Hana_Kernel-EXT/drivers/cpufreq/cpufreq_intellidemand.c Hana_Kernel-Source/drivers/cpufreq/cpufreq_intellidemand.c
cp Hana_Kernel-EXT/drivers/cpufreq/cpufreq_intellimm.c Hana_Kernel-Source/drivers/cpufreq/cpufreq_intellimm.c
cp Hana_Kernel-EXT/drivers/cpufreq/cpufreq_lionheart.c Hana_Kernel-Source/drivers/cpufreq/cpufreq_lionheart.c
cp Hana_Kernel-EXT/drivers/cpufreq/cpufreq_lulzactive.c Hana_Kernel-Source/drivers/cpufreq/cpufreq_lulzactive.c
cp Hana_Kernel-EXT/drivers/cpufreq/cpufreq_smartass2.c Hana_Kernel-Source/drivers/cpufreq/cpufreq_smartass2.c
rm Hana_Kernel-Source/drivers/crypto/msm/qcedev.c
cp Hana_Kernel-EXT/drivers/crypto/msm/qcedev.c Hana_Kernel-Source/drivers/crypto/msm/qcedev.c
rm Hana_Kernel-Source/drivers/input/misc/pmic8xxx-pwrkey.c
cp Hana_Kernel-EXT/drivers/input/misc/pmic8xxx-pwrkey.c Hana_Kernel-Source/drivers/input/misc/pmic8xxx-pwrkey.c
rm Hana_Kernel-Source/drivers/input/touchscreen/Kconfig
cp Hana_Kernel-EXT/drivers/input/touchscreen/Kconfig Hana_Kernel-Source/drivers/input/touchscreen/Kconfig
rm Hana_Kernel-Source/drivers/input/touchscreen/Makefile
cp Hana_Kernel-EXT/drivers/input/touchscreen/Makefile Hana_Kernel-Source/drivers/input/touchscreen/Makefile
cp Hana_Kernel-EXT/drivers/input/touchscreen/doubletap2wake.c Hana_Kernel-Source/drivers/input/touchscreen/doubletap2wake.c
cp Hana_Kernel-EXT/drivers/input/touchscreen/sweep2wake.c Hana_Kernel-Source/drivers/input/touchscreen/sweep2wake.c
rm Hana_Kernel-Source/drivers/input/touchscreen/synaptics-rmi/FIH-touch-tool/touch-tool_file_node_function.c
cp Hana_Kernel-EXT/drivers/input/touchscreen/synaptics-rmi/FIH-touch-tool/touch-tool_file_node_function.c Hana_Kernel-Source/drivers/input/touchscreen/synaptics-rmi/FIH-touch-tool/touch-tool_file_node_function.c
rm Hana_Kernel-Source/drivers/input/touchscreen/synaptics-rmi/synaptics_dsx_rmi4_i2c.c
cp Hana_Kernel-EXT/drivers/input/touchscreen/synaptics-rmi/synaptics_dsx_rmi4_i2c.c Hana_Kernel-Source/drivers/input/touchscreen/synaptics-rmi/synaptics_dsx_rmi4_i2c.c
rm Hana_Kernel-Source/drivers/gpu/Makefile
cp Hana_Kernel-EXT/drivers/gpu/Makefile Hana_Kernel-Source/drivers/gpu/Makefile
rm Hana_Kernel-Source/drivers/gpu/ion/Makefile
cp Hana_Kernel-EXT/drivers/gpu/ion/Makefile Hana_Kernel-Source/drivers/gpu/ion/Makefile
rm Hana_Kernel-Source/drivers/gpu/ion/msm/Makefile
cp Hana_Kernel-EXT/drivers/gpu/ion/msm/Makefile Hana_Kernel-Source/drivers/gpu/ion/msm/Makefile
rm Hana_Kernel-Source/drivers/staging/android/lowmemorykiller.c
cp Hana_Kernel-EXT/drivers/staging/android/lowmemorykiller.c Hana_Kernel-Source/drivers/staging/android/lowmemorykiller.c
rm Hana_Kernel-Source/drivers/usb/otg/msm_otg.c
cp Hana_Kernel-EXT/drivers/usb/otg/msm_otg.c Hana_Kernel-Source/drivers/usb/otg/msm_otg.c
rm Hana_Kernel-Source/drivers/video/cfbimgblt.c
cp Hana_Kernel-EXT/drivers/video/cfbimgblt.c Hana_Kernel-Source/drivers/video/cfbimgblt.c
rm Hana_Kernel-Source/drivers/video/cfbfillrect.c
cp Hana_Kernel-EXT/drivers/video/cfbfillrect.c Hana_Kernel-Source/drivers/video/cfbfillrect.c
rm Hana_Kernel-Source/fs/compat_ioctl.c
cp Hana_Kernel-EXT/fs/compat_ioctl.c Hana_Kernel-Source/fs/compat_ioctl.c
rm Hana_Kernel-Source/include/asm-generic/ioctls.h
cp Hana_Kernel-EXT/include/asm-generic/ioctls.h Hana_Kernel-Source/include/asm-generic/ioctls.h
cp Hana_Kernel-EXT/include/linux/compiler-gcc5.h Hana_Kernel-Source/include/linux/compiler-gcc5.h
rm Hana_Kernel-Source/include/linux/cpufreq.h
cp Hana_Kernel-EXT/include/linux/cpufreq.h Hana_Kernel-Source/include/linux/cpufreq.h
cp Hana_Kernel-EXT/include/linux/fastchg.h Hana_Kernel-Source/include/linux/fastchg.h
cp Hana_Kernel-EXT/include/linux/suspend.h Hana_Kernel-Source/include/linux/suspend.h
cp Hana_Kernel-EXT/include/linux/quickwakeup.h Hana_Kernel-Source/include/linux/quickwakeup.h
cp Hana_Kernel-EXT/include/linux/input/doubletap2wake.h Hana_Kernel-Source/include/linux/input/doubletap2wake.h
cp Hana_Kernel-EXT/include/linux/input/sweep2wake.h Hana_Kernel-Source/include/linux/input/sweep2wake.h
rm Hana_Kernel-Source/include/trace/events/cpufreq_interactive.h
cp Hana_Kernel-EXT/include/trace/events/cpufreq_interactive.h Hana_Kernel-Source/include/trace/events/cpufreq_interactive.h
rm Hana_Kernel-Source/init/Kconfig
cp Hana_Kernel-EXT/init/Kconfig Hana_Kernel-Source/init/Kconfig
rm Hana_Kernel-Source/lib/int_sqrt.c
cp Hana_Kernel-EXT/lib/int_sqrt.c Hana_Kernel-Source/lib/int_sqrt.c
rm Hana_Kernel-Source/kernel/sched/features.h
cp Hana_Kernel-EXT/kernel/sched/features.h Hana_Kernel-Source/kernel/sched/features.h
rm Hana_Kernel-Source/kernel/power/Kconfig
cp Hana_Kernel-EXT/kernel/power/Kconfig Hana_Kernel-Source/kernel/power/Kconfig
rm Hana_Kernel-Source/kernel/power/Makefile
cp Hana_Kernel-EXT/kernel/power/Makefile Hana_Kernel-Source/kernel/power/Makefile
cp Hana_Kernel-EXT/kernel/power/quickwakeup.c Hana_Kernel-Source/kernel/power/quickwakeup.c
rm Hana_Kernel-Source/mm/ksm.c
cp Hana_Kernel-EXT/mm/ksm.c Hana_Kernel-Source/mm/ksm.c
rm Hana_Kernel-Source/mm/huge_memory.c
cp Hana_Kernel-EXT/mm/huge_memory.c Hana_Kernel-Source/mm/huge_memory.c
rm Hana_Kernel-Source/mm/slub.c
cp Hana_Kernel-EXT/mm/slub.c Hana_Kernel-Source/mm/slub.c
rm Hana_Kernel-Source/net/netfilter/Makefile
cp Hana_Kernel-EXT/net/netfilter/Makefile Hana_Kernel-Source/net/netfilter/Makefile
cd Hana_Kernel-Source
echo "
###Running GCC Toolchains 5.4.0 (Crosstool-NG Toolchains)"

export ARCH=arm
export CROSS_COMPILE=/home/nicklas/crosstool-toolchains-5.4.X/bin/arm-unknown-linux-gnueabihf-

echo "
###Building Hana Kernel"

echo "
###Compile kernel process will write on log, for simple interface"

make ARCH=arm hana_kernel_nicki_defconfig
make ARCH=arm CROSS_COMPILE=/home/nicklas/crosstool-toolchains-5.4.X/bin/arm-unknown-linux-gnueabihf- > Hana-Log

echo "
##Creating Modules kernel"

mkdir modules
cp arch/arm/boot/zImage modules
find . -name "*.ko" -exec cp {} modules \;

echo "
## Preparing Hana Kernel"
cd /home/nicklas
mkdir Hana_ouput
mv Hana_Kernel-Source/modules Hana_output

echo "##Cleaning Build"
cd Hana_Kernel-Source
make clean && make mrproper

echo "##Creating Hana Kernel"
cd /home/nicklas/Hana_Kernel-EXT
./Hana_Kernel-builder.sh

echo "Script Complete Successfuly"
echo "Nicklas Van Dam @ XDA"
echo "Hana Kernel Finished"
echo "======Makihatayama Hana======"
