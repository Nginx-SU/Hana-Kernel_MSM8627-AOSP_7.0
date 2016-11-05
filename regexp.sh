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

find -name "*.c" | xargs sed -i "s/^__cpuinit //g"

echo "##Done"

echo
"###Running second regexp init"

find arch/ -name "*.h" | xargs sed -i "s/ __cpuinit//g"

echo "##Done"

echo
"###Running third regexp init"

find -name "*.c" | xargs sed -i "s/ __cpuinit$//g"

echo "##Done"

"###Running fourth regexp init"

find -name "*.c" | xargs sed -i "s/ __cpuinitdata//g"

echo "##Done"

echo
"###Running fifth regexp init"

find -name "*.c" | xargs sed -i "s/ __cpuexit / /g"

echo "##Done"

echo
"###Running sixth regexp init"

find -name "*.c" | xargs sed -i "s/ __cpuinit / /g"
echo "##Done"

echo "##Regexp process complete"

echo "======Makihatayama Hana======"
