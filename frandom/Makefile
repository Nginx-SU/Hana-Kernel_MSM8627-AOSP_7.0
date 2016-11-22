KERNEL_DIR=/home/nicklas/Hana_output

obj-m := frandom.o
PWD := $(shell pwd)
default:
	$(MAKE) ARCH=arm CROSS_COMPILE=/home/nicklas/Crosstool-NG_Toolchains-5.4.X/bin/arm-unknown-linux-gnueabihf- -C $(KERNEL_DIR) SUBDIRS=$(PWD) modules
clean:
	$(MAKE) -C $(KERNEL_DIR) SUBDIRS=$(PWD) clean
