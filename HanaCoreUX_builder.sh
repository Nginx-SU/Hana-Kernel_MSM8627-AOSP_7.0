#!/bin/bash
echo "Hana_Core.zip Builder"
echo "#######Nicklas Van Dam#######"
echo "###Starting...###"
cd /home/nicklas/Hana_CoreUX-EXT
mkdir work
cp Hana_Core-UX-nicki.zip work
cd work
unzip Hana_Core-UX-nicki.zip
cd /home/nicklas/Hana_output
mv zImage /home/nicklas/Hana_CoreUX-EXT/work/tmp/kernel/boot.img-zImage
cd /home/nicklas/Hana_CoreUX-EXT/work/system/lib
mkdir modules
cd /home/nicklas/Hana_output
mv *.ko /home/nicklas/Hana_CoreUX-EXT/work/system/lib/modules
cd /home/nicklas/Hana_CoreUX-EXT/work
rm Hana_Core-UX-nicki.zip
echo "###Creating Hana-Core.zip###"
zip -r Hana_Core_UX-nicki *
rm -rfv META-INF
rm -rfv system 
rm -rfv tmp
mv Hana_Core_UX-nicki.zip /home/nicklas/Hana_Core-UX_v1.2.5-nicki.zip
echo "###Cleaning..."
cd /home/nicklas/Hana_CoreUX-EXT
rm -rfv work
cd /home/nicklas
rm -rvf Hana_output
rm -rvf Hana_output
echo "###Sign Hana Core..."
mv Hana_Core-UX_v1.2.5-nicki.zip Hana_CoreUX-EXT/Hana_Signer/Hana_Core-UX_v1.2.5-nicki.zip
cd Hana_CoreUX-EXT/Hana_Signer
java -jar signapk.jar signature-key.Nicklas@XDA.x509.pem signature-key.Nicklas@XDA.pk8 Hana_Core-UX_v1.2.5-nicki.zip Hana_Core_v1.2.7-nicki-signed.zip
rm Hana_Core-UX_v1.2.5-nicki.zip
mv Hana_Core_v1.2.7-nicki-signed.zip /home/nicklas
echo "###Complete..."
