#!/bin/bash

echo "
######################################################
#                                                    #
#             Simple Regexp for __cpuinit            #
#                                                    #
#                Nicklas Van Dam @XDA                #
#                                                    #
#	           Royal Patraine		     #
######################################################"

echo "###Running first regexp init"

find -name "*.c" | xargs sed -i "s/^__cpuinit //g" > first-log

echo "##Done"

"###Running second regexp init"

find arch/ -name "*.h" | xargs sed -i "s/ __cpuinit//g" > second-log

echo "##Done"

"###Running third regexp init"

find -name "*.c" | xargs sed -i "s/ __cpuinit$//g" > third-log

echo "##Done"

"###Running fourth regexp init"

find -name "*.c" | xargs sed -i "s/ __cpuinitdata//g" > fourth-log

echo "##Done"

"###Running fifth regexp init"

find -name "*.c" | xargs sed -i "s/ __cpuexit / /g" > fifth-log

echo "##Done"

"###Running sixth regexp init"

find -name "*.c" | xargs sed -i "s/ __cpuinit / /g" > sixth-log

echo "##Done"

echo "##Creating log & Move it too log folder"

mkdir regexp_log

mv first-log regexp_log/1_log
mv second-log regexp_log/2_log
mv third-log regexp_log/3_log
mv fourth-log regexp_log/4_log
mv fifth-log regexp_log/5_log
mv sixth-log regexp_log/6_log

echo "##Done"

echo "##Regexp process complete"

echo "======Makihatayama Hana======"
