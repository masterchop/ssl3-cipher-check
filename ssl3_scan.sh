#!/bin/bash
#####################################################################################
#
# ssl3_scan.sh - Wrapper to run ssl3_cipher_check.sh to scan / test a network range
#
# Author  - Lamar Spells (lamar.spells@gmail.com)
# Blog    - http://foxtrot7security.blogspot.com
# Twitter - lspells
#
# Copyright (c) 2014, Lamar Spells
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
#   - Redistributions of source code must retain the above copyright notice, this
#     list of conditions and the following disclaimer.
#   - Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#
#####################################################################################

SSL3_CHECK_CIPHERS="./ssl3_cipher_check.sh"

if [ $# -lt 1 ] ; then
   echo "USAGE: `basename $0` <ip-range>"
   exit 1
fi

if [ $# -eq 1 ] ; then
  IP_RANGE=${1}
fi

echo "Beginning test... please be patient..."
nmap -PN -sT -p 443,4443,14443,8443,18443 -v  $IP_RANGE | grep ^Discovered | awk '{printf("%s:%s\n",$NF,$4)}'  | sed -e 's!/tcp!!g' | while read hn
do
   retcd=0
   $SSL3_CHECK_CIPHERS $hn > /dev/null 2>&1
   retcd=$?

   if [ $retcd -eq 0 ] ; then
      echo "$hn - SSL3.0 NOT supported"
   else
      if [ $retcd -eq 1 ] ; then
         echo "$hn - SSL3.0 supported"
      else
         echo "$hn - Error in connection"
      fi
   fi
done
exit 0

