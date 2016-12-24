#!/bin/bash
echo "Hana Kernel Builder"
echo "#######Nicklas Van Dam#######"
echo "###Starting...###"
cd /home/nicklas/Hana_Kernel-EXT
mkdir work
cp Hana_Kernel.zip work
cd work
unzip Hana_Kernel.zip
cd /home/nicklas/Hana_output/modules
mv zImage /home/nicklas/Hana_Kernel-EXT/work/tmp/kernel/boot.img-zImage
cd /home/nicklas/Hana_output
mv modules /home/nicklas/Hana_Kernel-EXT/work/system/lib
cd /home/nicklas/Hana_Kernel-EXT/work
rm Hana_Kernel.zip
echo "###Creating Hana Kernel###"
zip -r Hana_Kernel *
rm -rfv META-INF
rm -rfv system 
rm -rfv tmp
mv Hana_Kernel.zip /home/nicklas/Hana_Kernel-nicki.zip
echo "###Cleaning..."
cd /home/nicklas/Hana_Kernel-EXT
rm -rfv work
cd /home/nicklas
echo "###Sign Hana Kernel..."
mv Hana_Kernel-nicki.zip Hana_Kernel-EXT/Hana_Signer/Hana_Kernel_v1.0-nicki.zip
cd Hana_Kernel-EXT/Hana_Signer
java -jar signapk.jar signature-key.Nicklas@XDA.x509.pem signature-key.Nicklas@XDA.pk8 Hana_Kernel_v1.0-nicki.zip Hana_Kernel_v1.2.3.1-nicki-signed.zip
mv Hana_Kernel_v1.2.3.1-nicki-signed.zip /home/nicklas
rm Hana_Kernel_v1.0-nicki.zip
cd /home/nicklas
rm -rvf Hana_output
echo "###Complete..."
